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
            cudaSupport = true;
          };
        };
      in {
        devShells.default = pkgs.mkShell {
          # Add python313 and torch for shellHook test
          buildInputs = [
            (pkgs.python313.withPackages (ps:
              with ps; [
                torch
              ]))
          ];

          env = {
            CUDA_PATH = pkgs.cudaPackages.cudatoolkit;
          };

          shellHook = ''
            # Check cuda installation and pytorch cuda availability
            if ! command -v nvcc &> /dev/null
            then
                echo "nvcc could not be found"
                exit 1
            fi
            if ! python -c "import torch; print('CUDA : ' + str(torch.cuda.is_available()))"
            then
                echo "PyTorch CUDA is not available"
                exit 1
            fi
          '';
        };
      }
    );
}
