{
  description = "Simple flake with a dev shell for testing CUDA and PyTorch. Learn more at github.com/nixos-cuda/infra";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      # nix cuda maintainer cache allows to accelerate installation considerably, especially for cudnn which is very large and takes a long time to build
      "https://cache.nixos-cuda.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            # cudaSupport when set to true enables all pkgs that depend on its value to be built with cudaSupport.
            # Packages such as torchWithCuda will be built with cudaSupport to true but it won't be the same for other packages that might need cudaSupport to true in your project.
            cudaSupport = true;
          };
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Add pytorch for shellHook test
            (python313.withPackages (ps:
              with ps; [
                torch
              ]))

            # cuda packages
            (with cudaPackages; [
              # cuda compiler
              cuda_nvcc
              # Wrapper substituting the deprecated runfile-based CUDA installation
              cudatoolkit

              ### Other cuda packages (https://search.nixos.org/packages?channel=unstable&query=cudaPackages)
              ## GPU-accelerated library of primitives for deep neural networks
              # cudnn
              ## Library of primitives for image and signal processing
              # libnpp
            ])
          ];

          env = {
            CUDA_PATH = pkgs.cudaPackages.cudatoolkit;
          };

          shellHook = ''
            # Check cuda installation and pytorch cuda availability
            python -c "import torch; print('CUDA : ' + str(torch.cuda.is_available()))"
          '';
        };
      }
    );
}
