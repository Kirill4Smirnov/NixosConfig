{...}: {
  # PipeWire can briefly expose a card without an active profile while audio
  # devices are being initialized. GNOME Shell's bundled libgvc otherwise
  # dereferences that missing profile and crashes the entire login session.
  nixpkgs.overlays = [
    (_final: prev: {
      gnome-shell = prev.gnome-shell.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            ../Patches/gnome-shell/gvc-null-active-profile.patch
          ];
      });
    })
  ];
}
