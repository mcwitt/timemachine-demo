# Timemachine Demo

Notebook introducing the
[timemachine](https://github.com/proteneer/timemachine) molecular
dynamics engine with simple examples of vacuum Langevin dynamics and
free energy calculations.

## Quick start

1. An OpenEye license is currently required. Specify the path to the
   license file, e.g. by setting `OE_DIR`:

   ```console
   export OE_DIR=~/.openeye
   ```

### Using conda/mamba

1. To enable CUDA support (requires Linux and a compatible GPU),
   install CUDA Toolkit 11.6 or greater. Otherwise, set

   ```
   export SKIP_CUSTOM_OPS=1
   ```

    to skip building CUDA kernels.

1. Install and activate environment with conda (or [mamba](https://github.com/mamba-org/mamba))

   ```console
   conda env create -f environment.yml -n timemachine-demo
   conda activate timemachine-demo
   ```

1. Launch Jupyter Lab

   ```console
   jupyter lab
   ```

### Using Nix (Linux+CUDA only)

1. Install the [Nix package manager](https://nixos.org/download.html)
   and enable [flakes support](https://nixos.wiki/wiki/Flakes).

1. To enter a reproducible Jupyter Lab environment with all the required dependencies

    ```
    nix run
    ```

1. To enter a development environment

    ```
    nix develop
    ```
