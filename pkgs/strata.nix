{ lib
, cmake
, ninja
, makeWrapper
, python3
, strataSrc
, cudaPkg
}:

let
  stdenv = cudaPkg.backendStdenv;

  cudaArch = "75-real;75-virtual";

  # requirements.txt's packages, plus textual for `strata monitor`.
  pythonEnv = python3.withPackages (ps: with ps; [
    numpy
    jinja2
    regex
    pyyaml
    tqdm
    requests
    pillow
    psutil
    textual
  ]);

  version = lib.head (builtins.match "project\\(strata VERSION ([0-9.]+).*"
    (lib.findFirst (lib.hasPrefix "project(strata VERSION ") ""
      (lib.splitString "\n" (lib.readFile "${strataSrc}/engine/CMakeLists.txt"))));

  # "75-real;75-virtual" -> [ 75 ]: BUILD.json names architectures by number.
  archs = lib.unique (map (a: lib.toInt (lib.head (lib.splitString "-" a)))
    (lib.splitString ";" cudaArch));

  buildInfo = builtins.toJSON {
    inherit version archs;
    source = "nix";
    cuda = cudaPkg.cudatoolkit.version;
    vision = "cpu";
  };
in
stdenv.mkDerivation {
  pname = "strata";
  inherit version;

  src = strataSrc;

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
    cudaPkg.cuda_nvcc
  ];

  buildInputs = [
    cudaPkg.cuda_cudart
    cudaPkg.libcublas
    cudaPkg.cccl
  ];

  strictDeps = true;

  # tools/packaging/build_cuda_linux.sh's CUDA 13 release recipe.
  configurePhase = ''
    runHook preConfigure

    cmake -G Ninja -S engine -B build-engine \
      -DCMAKE_BUILD_TYPE=Release \
      -DSTRATA_ENABLE_CUDA=ON \
      -DSTRATA_BUILD_TESTS=OFF \
      -DSTRATA_EXPERIMENTAL_SM60=OFF \
      -DSTRATA_NATIVE_EXPERTS=ON \
      -DSTRATA_PORTABLE=ON \
      -DSTRATA_Q6K_EXPERTS=ON \
      "-DCMAKE_CUDA_ARCHITECTURES=${cudaArch}" \
      -DCMAKE_CUDA_COMPILER=${cudaPkg.cuda_nvcc}/bin/nvcc \
      -DCMAKE_CUDA_HOST_COMPILER=${stdenv.cc}/bin/c++

    cmake -G Ninja -S terminal/tools/vision -B build-vision \
      -DCMAKE_BUILD_TYPE=Release \
      -DSTRATA_PORTABLE=ON

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    cmake --build build-engine --target strata
    cmake --build build-vision --target strata-vision

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/strata/engine $out/bin

    cp -r --no-preserve=mode $src/terminal/. $out/lib/strata

    install -m755 build-engine/strata $out/lib/strata/engine/
    install -m755 build-vision/bin/strata-vision $out/lib/strata/engine/

    echo ${lib.escapeShellArg buildInfo} >$out/lib/strata/engine/BUILD.json

    makeWrapper ${pythonEnv}/bin/python3 $out/bin/strata-server \
      --add-flags "$out/lib/strata/serve/server.py"

    makeWrapper ${pythonEnv}/bin/python3 $out/bin/strata \
      --add-flags "$out/lib/strata/strata.py"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Strata inference engine and its OpenAI-compatible local server";
    homepage = "https://github.com/Niko1221/Strata";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
