{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.v2rayn
    pkgs.xray
  ];

  home-manager.users.kenlog.home.file = {
    ".local/share/v2rayN/bin/xray/xray".source = "${pkgs.xray}/bin/xray";
    ".local/share/v2rayN/bin/geosite.dat".source = "${pkgs.v2ray-rules-dat}/share/v2ray/geosite.dat";
    ".local/share/v2rayN/bin/geoip.dat".source = "${pkgs.v2ray-rules-dat}/share/v2ray/geoip.dat";
  };
}
