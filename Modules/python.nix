{
  inputs,
  pkgs,
  ...
}: let
  python = pkgs.python3.override {
    packageOverrides = self: super: {
      # plotly tests currently fail in nixpkgs with newer pytest warnings
      plotly = super.plotly.overridePythonAttrs (_old: {
        doCheck = false;
      });

      kaleido = super.kaleido.overridePythonAttrs (_old: {
        doCheck = false;
      });
    };
  };
in {
  hm.home.packages = [
    (python.withPackages (ps:
      with ps; [
        ipympl
        ipython
        jupyter
        matplotlib
        mypy
        numpy
        pandas
        seaborn
        tqdm
        numba
        sympy
        scipy
        statsmodels
        scikit-learn
        plotly
      ]))
  ];
}
