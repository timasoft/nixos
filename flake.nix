{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix/release-26.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    # dw-proton.url = "github:imaviso/dwproton-flake";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    llama-cpp.url = "github:ggml-org/llama.cpp";
    llama-cpp.inputs.nixpkgs.follows = "nixpkgs";
    mcp-secure-exec.url = "github:timasoft/mcp-secure-exec";
    mcp-secure-exec.inputs.nixpkgs.follows = "nixpkgs";
    comfy.url = "github:nixified-ai/flake";
    ambiway.url = "github:timasoft/ambiway";
    ambiway.inputs.nixpkgs.follows = "nixpkgs";
    cava-bg.url = "github:timasoft/cava-bg";
    cava-bg.inputs.nixpkgs.follows = "nixpkgs";
    noctalia.url = "github:noctalia-dev/noctalia";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixvim,
    stylix,
    # dw-proton,
    nix-index-database,
    llama-cpp,
    mcp-secure-exec,
    comfy,
    ambiway,
    cava-bg,
    noctalia,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = true;
      config.cudaCapabilities = [ "7.5" ];
      overlays = [ pipx-fix-overlay ];
    };
    pipx-fix-overlay = final: prev: {
      pipx = prev.pipx.overridePythonAttrs (old: {
        doCheck = false;
      });
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
    ambiwayPkg = ambiway.packages.${system}.default;
    noctaliaPkg = noctalia.packages.${system}.default;
    comfyuiPackage = comfy.packages.${system}.comfyui-nvidia;
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
        # {
        #   programs.steam.extraCompatPackages = [
        #     dw-proton.packages.${pkgs.stdenv.hostPlatform.system}.dw-proton
        #   ];
        # }
        mcp-secure-exec.nixosModules.mcp-secure-exec
        comfy.nixosModules.comfyui
      ];
      specialArgs = {
        inherit comfyuiPackage;
        unstable = unstablePkgs;
        stable = pkgs;
      };
    };

    homeConfigurations.tima = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit ambiwayPkg;
        inherit noctaliaPkg;
        unstable = unstablePkgs;
      };
      modules = [
        nixvim.homeModules.nixvim
        stylix.homeModules.stylix
        noctalia.homeModules.default
        cava-bg.homeManagerModules.cava-bg
        ./home.nix
      ];
    };
  };
}
