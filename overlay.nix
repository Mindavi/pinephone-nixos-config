self: super: {
  glibc = super.glibc.overrideAttrs (old: {
    separateDebugInfo = false;
  });
  openssl = super.openssl.overrideAttrs (old: {
    separateDebugInfo = false;
  });
  gdk-pixbuf = super.gdk-pixbuf.overrideAttrs (old: {
    separateDebugInfo = false;
  });
  glib = super.glib.overrideAttrs (old: {
    separateDebugInfo = false;
  });
  curl = super.curl.overrideAttrs (old: {
    separateDebugInfo = false;
  });
  valgrind = super.valgrind.overrideAttrs (old: {
    separateDebugInfo = false;
  });
}
