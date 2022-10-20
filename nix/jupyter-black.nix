{ buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, black
, ipython
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "jupyter-black";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8LCmCo6oMCqNZZR6q2kSOK3bKAah1ljrWpgHj+tEgRw=";
  };

  format = "pyproject";

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    black
    ipython
    tokenize-rt
  ];

  pythonRelaxDeps = [ "ipython" ];
}
