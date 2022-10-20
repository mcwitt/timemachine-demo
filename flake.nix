{
  description = "timemachine environment";

  inputs = {
    mdtraj.url = "github:mdtraj/mdtraj";
    nixpkgs.url = "github:nixos/nixpkgs";
    timemachine-flake = {
      url = "github:mcwitt/timemachine-flake";
      inputs.timemachine-src.url = "github:proteneer/timemachine/70aef22f702112c6bb87f4ca2c7da3fe460e2b3b";
    };
  };
  outputs =
    { mdtraj
    , nixpkgs
    , timemachine-flake
    , ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          mdtraj.overlay
          timemachine-flake.overlay
        ];
      };

      python3 = pkgs.python3.override (old: {
        packageOverrides = nixpkgs.lib.composeExtensions old.packageOverrides (final: prev: {
          jupyter-black = final.callPackage ./nix/jupyter-black.nix { };
          mdtraj = prev.mdtraj.overrideAttrs (_: { doInstallCheck = false; });
          timemachine = prev.timemachine.overrideAttrs (_: { doInstallCheck = false; });
        });
      });

      pythonEnv = python3.withPackages (ps: with ps; [
        black
        diskcache
        graphviz
        isort
        jaxlib
        jupyter-black
        matplotlib
        mols2grid
        notebook
        ps.mdtraj
        py3Dmol
        timemachine
        tqdm
      ]);
    in
    {
      devShells.${system}.default = pythonEnv.env;
    };
}
