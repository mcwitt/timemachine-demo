{
  description = "timemachine notebook environment";

  inputs = {
    jupyterWith.url = github:tweag/jupyterWith;
    mdtraj.url = github:mdtraj/mdtraj;
    nixpkgs.url = github:nixos/nixpkgs;
    timemachine-flake.url = github:mcwitt/timemachine-flake;
  };
  outputs =
    { jupyterWith
    , mdtraj
    , nixpkgs
    , timemachine-flake
    , ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          jupyterWith.overlays.jupyterWith
          jupyterWith.overlays.python
          mdtraj.overlay
          timemachine-flake.overlay
        ];
      };

      python3 = pkgs.python3.override (old: {
        packageOverrides = nixpkgs.lib.composeExtensions old.packageOverrides (final: prev: {

          jupyter-black = final.buildPythonPackage rec {
            pname = "jupyter-black";
            version = "0.3.1";

            src = final.fetchPypi {
              inherit pname version;
              sha256 = "sha256-8LCmCo6oMCqNZZR6q2kSOK3bKAah1ljrWpgHj+tEgRw=";
            };

            format = "pyproject";

            propagatedBuildInputs = with python3.pkgs; [
              black
              python3.pkgs.ipython
              tokenize-rt
            ];

            postPatch = ''
              substituteInPlace setup.cfg --replace "ipython >= 7.27.0, < 8" "ipython >= 7.27.0"
            '';
          };

          mdtraj = prev.mdtraj.overrideAttrs (_: { doInstallCheck = false; });
        });
      });

      pkgFun = ps: with ps; [
        black
        diskcache
        graphviz
        isort
        jaxlib
        matplotlib
        ps.mdtraj
        mols2grid
        timemachine
        tqdm
      ];

      pythonEnv = python3.withPackages pkgFun;

      ipython = pkgs.kernels.iPythonWith {
        name = "python3-timemachine";
        inherit python3;
        packages = ps: pkgFun ps ++ (with ps; [
          ipywidgets
          jupyter-black
          py3Dmol
        ]);
        ignoreCollisions = true;
      };

      jupyterEnv = pkgs.jupyterlabWith { kernels = [ ipython ]; };

    in
    {
      apps.${system} = rec {
        jupyter-lab = {
          type = "app";
          program = "${jupyterEnv}/bin/jupyter-lab";
        };

        default = jupyter-lab;
      };

      devShells.${system} = {
        default = pythonEnv.env;
        pythonEnv = pythonEnv.env;
        jupyterEnv = jupyterEnv.env;
      };
    };
}
