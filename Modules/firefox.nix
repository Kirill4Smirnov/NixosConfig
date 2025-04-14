{pkgs, ...}: {
  home-manager.users.kenlog = {
    programs.firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          simple-translate
          decentraleyes
          ublock-origin
          vimium
        ];
        settings = {
          # GPU
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;

          # Disable pocket
          "extensions.pocket.enabled" = false;
          "browser.newtabpage.activity-stream.discoverystream.saveToPocketCard.enabled" = false;

          # Disable lockwise
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "signon.formlessCapture.enabled" = false;

          # Enable containers
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          # Disable fakespot shopping sidebar
          "browser.shopping.experience2023.enabled" = false;
          "browser.shopping.experience2023.optedIn" = 2;
          "browser.shopping.experience2023.active" = false;

          # Block DRM
          "media.eme.enabled" = false;
          "media.gmp-manager.url" = "data:text/plain,";
          "media.gmp-provider.enabled" = false;
          "media.gmp-gmpopenh264.enabled" = false;

          # Privacy
          "privacy.query_stripping.strip_list" = "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid";
          "network.http.referer.XOriginTrimmingPolicy" = 2;
          "media.peerconnection.ice.default_address_only" = true;

          # Telemetry
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.coverage.opt-out" = true;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.enabled" = false;
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "browser.tabs.crashReporting.sendReport" = false;

          # Security
          "security.ssl.require_safe_negotiation" = true;
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "security.remote_settings.crlite_filters.enabled" = true;
          "security.OCSP.require" = true;

          # Disable safebrowsing
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.provider.google4.gethashURL" = "";
          "browser.safebrowsing.provider.google4.updateURL" = "";
          "browser.safebrowsing.provider.google.gethashURL" = "";
          "browser.safebrowsing.provider.google.updateURL" = "";
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
          "browser.safebrowsing.downloads.remote.block_uncommon" = false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.provider.google4.dataSharingURL" = "";

          # New tab
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        };
      };
    };
  };
}
