{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    dw-proton.url = "github:imaviso/dwproton-flake";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    llama-cpp.url = "github:ggml-org/llama.cpp";
    llama-cpp.inputs.nixpkgs.follows = "nixpkgs";
    mcp-secure-exec.url = "github:timasoft/mcp-secure-exec";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixvim,
    stylix,
    dw-proton,
    nix-index-database,
    llama-cpp,
    mcp-secure-exec,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = true;
      config.cudaCapabilities = [ "7.5" ];
    };
    unstablePkgs = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = true;
      config.cudaCapabilities = [ "7.5" ];
      overlays = [
        llama-cpp.overlays.default
      ];
    };
  in {
    nixosConfigurations.timofey = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        nix-index-database.nixosModules.default
        { programs.nix-index-database.comma.enable = true; }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        {
          programs.steam.extraCompatPackages = [
            dw-proton.packages.${pkgs.stdenv.hostPlatform.system}.dw-proton
          ];
        }
        mcp-secure-exec.nixosModules.mcp-secure-exec
      ];
      specialArgs = {
        unstable = unstablePkgs;
        stable = pkgs;
      };
    };

    homeConfigurations.tima = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        unstable = unstablePkgs;
      };
      modules = [
        nixvim.homeManagerModules.nixvim
        stylix.homeModules.stylix
        ./home.nix
      ];
    };
  };
}
