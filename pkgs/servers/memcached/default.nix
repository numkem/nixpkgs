{stdenv, fetchurl, cyrus_sasl, libevent}:

stdenv.mkDerivation rec {
  version = "1.5.20";
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/${pname}-${version}.tar.gz";
    sha256 = "1r511qr95q0ywdaql3pdjiwzkfqxhhfzb13ilvl7mznfm4iv1myg";
  };

  configureFlags = [
     "ac_cv_c_endian=${if stdenv.hostPlatform.isBigEndian then "big" else "little"}"
  ];

  buildInputs = [cyrus_sasl libevent];

  hardeningEnable = [ "pie" ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-Wno-error";

  meta = with stdenv.lib; {
    description = "A distributed memory object caching system";
    repositories.git = https://github.com/memcached/memcached.git;
    homepage = http://memcached.org/;
    license = licenses.bsd3;
    maintainers = [ maintainers.coconnor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
