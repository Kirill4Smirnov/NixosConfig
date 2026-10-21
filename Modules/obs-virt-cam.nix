{config, ...}: {
  boot.extraModulePackages = [
    (config.boot.kernelPackages.v4l2loopback.overrideAttrs (old: {
      # Kernel 6.12.113 runs depmod during modules_install. Its generated
      # modules.* files then collide with the kernel's own module metadata.
      makeFlags = (old.makeFlags or []) ++ ["DEPMOD=true"];
    }))
  ];
  boot.kernelModules = ["v4l2loopback"];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
}
