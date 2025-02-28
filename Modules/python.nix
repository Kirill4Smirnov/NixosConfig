{
  inputs,
  pkgs,
  ...
}: {
  hm.home.packages = [
    (
      pkgs.python3.withPackages
      (ps:
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
        ])
    )
    # pkgs.python311Packages.private-gpt
  ];
}
