{
  lib,
  stdenv,
  pkgs,
  fetchurl,
  dpkg,
  buildFHSEnv,
}: let
  # Import the modular JSON file
  sources = lib.importJSON ./sources.json;

  adspower-raw = stdenv.mkDerivation {
    pname = "adspower";
    version = sources.version;

    src = fetchurl {
      url = sources.url;
      hash = sources.hash;
    };

    nativeBuildInputs = [dpkg];
    dontBuild = true;
    dontConfigure = true;

    unpackPhase = ''
      dpkg-deb -x $src ./unpacked
    '';

    installPhase = ''
      mkdir -p $out/opt/adspower
      cp -r unpacked/opt/AdsPower\ Global/* $out/opt/adspower/

      mkdir -p $out/share/applications
      cp unpacked/usr/share/applications/adspower_global.desktop $out/share/applications/
      substituteInPlace $out/share/applications/adspower_global.desktop \
        --replace-warn "/opt/AdsPower Global/adspower_global" "adspower_global"
    '';
  };
in
  buildFHSEnv {
    name = "adspower_global";

    targetPkgs = pkgs:
      with pkgs; [
        alsa-lib
        at-spi2-atk
        atk
        cairo
        cups
        dbus
        expat
        fontconfig
        freetype
        gdk-pixbuf
        glib
        gtk3
        libappindicator-gtk3
        libdrm
        libGL
        libgbm
        libnotify
        libsecret
        libxkbcommon
        libxshmfence
        mesa
        nspr
        nss
        pango
        stdenv.cc.cc.lib
        systemd
        udev
        util-linux
        libX11
        libxcb
        libXcomposite
        libXcursor
        libXdamage
        libXext
        libXfixes
        libXi
        libXrandr
        libXrender
        libXScrnSaver
        libXtst

        bash
        xdg-utils
        coreutils
        curl
        wget
      ];

    runScript = "${adspower-raw}/opt/adspower/adspower_global";
    extraInstallCommands = ''
      mkdir -p $out/share
      cp -r ${adspower-raw}/share/* $out/share/
    '';
    meta = with lib; {
      description = "AdsPower Global (Modular FHS Environment)";
      homepage = "https://www.adspower.com/";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  }
