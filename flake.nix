{
  description = "flake template for cuda";

  # Using cachix to avoid killing yourself with slow builds
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
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
        pythonWithPackages = pkgs.python312.withPackages (ps:
          with ps; [
            # example packages
            torch
            torchvision
            torchaudio
          ]);
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            pythonWithPackages

            cudaPackages.cudatoolkit
            cudaPackages.cudnn
          ];
          shellHook = ''
            export CUDA_PATH=${pkgs.cudatoolkit}
            export LD_LIBRARY_PATH=${pkgs.cudatoolkit}/lib:$LD_LIBRARY_PATH
            export EXTRA_CCFLAGS="-I/usr/include"

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
