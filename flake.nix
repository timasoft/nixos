{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    # dw-proton.url = "github:imaviso/dwproton-flake";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    llama-cpp.url = "github:ggml-org/llama.cpp";
    llama-cpp.inputs.nixpkgs.follows = "nixpkgs";
    mcp-secure-exec.url = "github:timasoft/mcp-secure-exec";
    mcp-secure-exec.inputs.nixpkgs.follows = "nixpkgs";
    comfy.url = "github:nixified-ai/flake";
    comfy.inputs.nixpkgs.follows = "nixpkgs";
    ambiway.url = "github:timasoft/ambiway";
    ambiway.inputs.nixpkgs.follows = "nixpkgs";
    cava-bg.url = "github:timasoft/cava-bg";
    cava-bg.inputs.nixpkgs.follows = "nixpkgs";
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
    ui-assets = {
      index      = pkgs.fetchurl { url = "https://huggingface.co/buckets/ggml-org/llama-ui/resolve/b9453/index.html";     sha256 = "1wsapkb24yhh51zqs93s4izy6nhm2blxk15d64pwqvj5d6n6v99y"; };
      bundle_js  = pkgs.fetchurl { url = "https://huggingface.co/buckets/ggml-org/llama-ui/resolve/b9453/bundle.js";     sha256 = "1lbw2n4gv68bvh7qhvxf461qab44v94gc6wpzxr34m8lms677jyf"; };
      bundle_css = pkgs.fetchurl { url = "https://huggingface.co/buckets/ggml-org/llama-ui/resolve/b9453/bundle.css";   sha256 = "14vyn8kgz62dwvmy1vngs7yyq7m29z16r8vxrnfc6x9zx5gwpgq2"; };
      loading    = pkgs.fetchurl { url = "https://huggingface.co/buckets/ggml-org/llama-ui/resolve/b9453/loading.html"; sha256 = "1p1wf1xrwbc66c6s7cj7pf5ba1v1kw0mv3xj2s6m30db75z0a015"; };
    };
    pipx-fix-overlay = final: prev: {
      pipx = prev.pipx.overridePythonAttrs (old: {
        doCheck = false;
      });
    };
    llama-cpp-fix-overlay = final: prev: {
      llamaPackages = prev.llamaPackages // {
        llama-cpp = prev.llamaPackages.llama-cpp.overrideAttrs (old: {
          preBuild = (old.preBuild or "") + ''
            mkdir -p tools/ui/dist
            cp ${ui-assets.index}      tools/ui/dist/index.html
            cp ${ui-assets.bundle_js}  tools/ui/dist/bundle.js
            cp ${ui-assets.bundle_css} tools/ui/dist/bundle.css
            cp ${ui-assets.loading}    tools/ui/dist/loading.html
          '';
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
        comfy.overlays.comfyui
      ];
    };
    ambiwayPkg = ambiway.packages.${system}.default;
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
        unstable = unstablePkgs;
        stable = pkgs;
      };
    };

    homeConfigurations.tima = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit ambiwayPkg;
        unstable = unstablePkgs;
      };
      modules = [
        nixvim.homeModules.nixvim
        stylix.homeModules.stylix
        cava-bg.homeManagerModules.cava-bg
        ./home.nix
      ];
    };
  };
}
