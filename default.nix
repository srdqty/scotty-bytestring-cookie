{ mkDerivation, base, bytestring, case-insensitive, cookie, hpack
, hspec, hspec-wai, http-types, mtl, scotty, scotty-bytestring
, stdenv, text, time, wai
}:
mkDerivation {
  pname = "scotty-bytestring-cookie";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base bytestring case-insensitive cookie http-types mtl scotty
    scotty-bytestring time wai
  ];
  libraryToolDepends = [ hpack ];
  testHaskellDepends = [
    base bytestring case-insensitive cookie hspec hspec-wai http-types
    mtl scotty scotty-bytestring text time wai
  ];
  preConfigure = "hpack";
  homepage = "https://github.com/srdqty/scotty-bytestring-cookie#readme";
  description = "Functions for reading and writing HTTP cookies with Scotty";
  license = stdenv.lib.licenses.bsd3;
}
