{ stdenv, fetchurl, gettext, pkgconfig, meson, ninja
, gnome3, glib, gtk3, ncurses, gobject-introspection, vala, libxml2, gnutls
, gperf, pcre2
}:

stdenv.mkDerivation rec {
  pname = "vte";
  version = "0.58.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0ifvza9sdrkxxqq7m9i7ry23sv7widjz6nzbvgc60kpph4fmf187";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = pname; };
  };

  nativeBuildInputs = [
    meson ninja gobject-introspection gettext pkgconfig vala gperf libxml2
  ];
  buildInputs = [ glib gtk3 ncurses ];

  propagatedBuildInputs = [
    # Required by vte-2.91.pc.
    gtk3
    gnutls
    pcre2
  ];

  preConfigure = "patchShebangs .";

  mesonFlags = [
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.gnome.org/;
    description = "A library implementing a terminal emulator widget for GTK";
    longDescription = ''
      VTE is a library (libvte) implementing a terminal emulator widget for
      GTK, and a minimal sample application (vte) using that.  Vte is
      mainly used in gnome-terminal, but can also be used to embed a
      console/terminal in games, editors, IDEs, etc. VTE supports Unicode and
      character set conversion, as well as emulating any terminal known to
      the system's terminfo database.
    '';
    license = licenses.lgpl2;
    maintainers = with maintainers; [ astsmtl antono lethalman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
