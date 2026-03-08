# This module provides support for NVIDIA CUDA on NixOS. It includes the necessary packages and configurations to enable CUDA functionality on the system.

{
  ...
}: {
  flake.nixosModules.cuda = {
    config,
    pkgs,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      cudaPackages.cudatoolkit
      cudaPackages.cudnn
      linuxPackages.nvidia_x11
    ];

    environment.sessionVariables = {
      CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    };

    programs.nix-required-mounts = {
      enable = true;
      presets.nvidia-gpu.enable = true;
    };
  };
}
