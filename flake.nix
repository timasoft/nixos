{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    unstablePkgs = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations.timofey = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
	{
	  home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.tima = {
	      imports = [
	        nixvim.homeManagerModules.nixvim
	        ./home.nix
	      ];
	  };
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
