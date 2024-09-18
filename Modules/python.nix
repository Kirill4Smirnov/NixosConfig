{
  inputs,
  pkgs,
  ...
}: {
  hm.home.packages = [
    (pkgs.python31111111111111111111111.withPackages
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
        ]))
  ];
}
