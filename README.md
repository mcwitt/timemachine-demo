# Timemachine Demo

Notebook introducing the
[timemachine](https://github.com/proteneer/timemachine) molecular
dynamics engine with simple examples of vacuum Langevin dynamics and
free energy calculations.

## Quick start

1. If CUDA is *not* available (e.g. on a Mac), set

   ```
   export SKIP_CUSTOM_OPS=1
   ```

    to skip building CUDA kernels.

1. Install and activate environment with conda (or [mamba](https://github.com/mamba-org/mamba))

   ```console
   conda env create -f environment.yml -n timemachine-demo
   conda activate timemachine-demo
   ```

1. Specify location of OpenEye license file, e.g.

   ```console
   export OE_DIR=~/.openeye
   ```

1. Launch Jupyter Lab

   ```console
   jupyter lab
   ```
