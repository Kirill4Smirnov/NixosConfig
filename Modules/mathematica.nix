{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (mathematica.override {
      version = "14.0.0";
      webdoc = false;

      source = inputs.mathematica-installer;
      /*
        source = pkgs.requireFile {
        name = "Mathematica_14.0.0_BNDL_LINUX.sh";
        # Get this hash via a command similar to this:
        # nix-store --query --hash \
        # $(nix store add-path Mathematica_XX.X.X_BNDL_LINUX.sh --name 'Mathematica_XX.X.X_BNDL_LINUX.sh')
        sha256 = "sha256:1q4k7m7pdny2svqx7dqm6wdrhdjjg86jksw3ygy52kgn7sq5py74";
        message = ''
          Your override for Mathematica includes a different src for the installer,
          and it is missing.
        '';
        hashMode = "recursive";
      };
      */
    })
  ];
}
