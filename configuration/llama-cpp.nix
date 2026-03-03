{ config, unstable, ... }:

{
  environment.systemPackages = [
    (unstable.llama-cpp.override {
      cudaSupport = true;
    })
  ];
}
