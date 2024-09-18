{
  inputs,
  pkgs,
  ...
}: {
  hm.home.packages = [
    (pkgs.python311.withPackages
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
