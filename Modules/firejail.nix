{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    zoom-us
  ];

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      zoom-us = {
        executable = "${pkgs.zoom-us}/bin/zoom-us";
        extraArgs = [
          # Enable system notifications
          "--dbus-user.talk=org.freedesktop.Notifications"
        ];
      };
    };
  };
}
