{ config, pkgs, ... }:

{
  # Install LlamaCPP with Vulkan acceleration built-in
  environment.systemPackages = [
    (pkgs.llama-cpp.override {
      vulkanSupport = true;
    })
  ];
}
