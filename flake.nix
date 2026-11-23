{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-master.url = "github:nix-community/home-manager/master";
    home-manager-master.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    # nixvim.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix/release-26.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    dw-proton.url = "github:imaviso/dwproton-flake";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    llama-cpp.url = "github:ggml-org/llama.cpp";
    llama-cpp.inputs.nixpkgs.follows = "nixpkgs";
    comfy.url = "github:nixified-ai/flake";
    ambiway.url = "github:timasoft/ambiway";
    ambiway.inputs.nixpkgs.follows = "nixpkgs";
    cava-bg.url = "github:timasoft/cava-bg";
    cava-bg.inputs.nixpkgs.follows = "nixpkgs";
    zapret-rust.url = "github:Sergeydigl3/zapret-discord-youtube-rust";
    zapret-rust.inputs.nixpkgs.follows = "nixpkgs";
    vinsa-tablet.url = "github:timasoft/Tablet-VINSA-1060-Plus-Linux-Driver";
    # The repo root has no flake.nix (only tools/nix/flake.nix, a dev shell), so it is a source input.
    strata.url = "github:Niko1221/Strata";
    strata.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    home-manager-master,
    nixvim,
    stylix,
    dw-proton,
    nix-index-database,
    llama-cpp,
    comfy,
    ambiway,
    cava-bg,
    zapret-rust,
    vinsa-tablet,
    strata,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ pipx-fix-overlay ];
    };
    pipx-fix-overlay = final: prev: {
      pipx = prev.pipx.overridePythonAttrs (old: {
        doCheck = false;
      });
    };
    llama-cpp-fix-overlay = final: prev: {
      llamaPackages = prev.llamaPackages // {
        llama-cpp = prev.llamaPackages.llama-cpp.overrideAttrs (drv: {
          cmakeFlags = drv.cmakeFlags ++ [ "-DCMAKE_CUDA_FLAGS=-I${prev.cudaPackages.cuda_nvml_dev.include}/include" ];
          webui = drv.webui.overrideAttrs (webui: {
            postPatch = ''
              substituteInPlace scripts/brand-favicons.ts --replace-fail \
                "copyFileSync(require.resolve(specifier), resolve(outDir, fileName));" \
                "copyFileSync(require.resolve(specifier), resolve(outDir, fileName)); require('node:fs').chmodSync(resolve(outDir, fileName), 0o644);"
            '';
          });
        });
      };
    };
    unstablePkgs = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = true;
      config.cudaCapabilities = [ "7.5" ];
      overlays = [
        llama-cpp.overlays.default
        llama-cpp-fix-overlay
      ];
    };
    ambiwayPkg = ambiway.packages.${system}.default;
    comfyuiPackage = comfy.packages.${system}.comfyui-nvidia;
    # Built from the CUDA 13.0 set of the unstable channel: nvcc 13 wants that set's host compiler,
    # and the package takes its stdenv from the cudaPkg it is given.
    strataPkg = unstablePkgs.callPackage ./pkgs/strata.nix {
      strataSrc = strata;
      cudaPkg = unstablePkgs.cudaPackages_13_0;
    };
  in {
    packages."${system}".strata = strataPkg;

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
        comfy.nixosModules.comfyui
        zapret-rust.nixosModules.zapret-rust
        vinsa-tablet.nixosModules.vinsa-tablet
      ];
      specialArgs = {
        inherit comfyuiPackage strataPkg;
        unstable = unstablePkgs;
        stable = pkgs;
      };
    };

    homeConfigurations.tima = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit ambiwayPkg;
        inherit nixvim;
        unstable = unstablePkgs;
        hmMaster = home-manager-master.outPath;
      };
      modules = [
        nixvim.homeModules.nixvim
        stylix.homeModules.stylix
        (home-manager-master + "/modules/programs/noctalia/default.nix")
        ./home/herdr-master.nix
        cava-bg.homeManagerModules.cava-bg
        ./home.nix
      ];
    };
  };
}
