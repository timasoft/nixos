{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix/release-25.11";
    # aagl.inputs.nixpkgs.follows = "nixpkgs";
    dw-proton.url = "github:imaviso/dwproton-flake";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixvim,
    # aagl,
    dw-proton,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    unstablePkgs = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations.timabook = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        # {
        #   imports = [ aagl.nixosModules.default ];
        #   programs.anime-game-launcher.enable = true;
        # }
        {
          programs.steam.extraCompatPackages = [
            dw-proton.packages.${pkgs.stdenv.hostPlatform.system}.dw-proton
          ];
        }
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
        ./home.nix
        ];
    };
  };
}
