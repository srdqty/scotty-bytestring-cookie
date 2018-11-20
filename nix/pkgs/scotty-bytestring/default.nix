{ mkDerivation, base, bytestring, case-insensitive, fetchgit, hpack
, hspec, hspec-wai, http-types, mtl, scotty, stdenv, text, wai
}:
mkDerivation {
  pname = "scotty-bytestring";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/srdqty/scotty-bytestring.git";
    sha256 = "0349bn0ndmsqhjgd8hc5dnci70rvai2bii0jpj4dj4yk0vbgq8gf";
    rev = "34480731cb79a23d9f7fefe228f403efbe69c00e";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base bytestring case-insensitive http-types mtl scotty wai
  ];
  libraryToolDepends = [ hpack ];
  testHaskellDepends = [
    base bytestring case-insensitive hspec hspec-wai http-types mtl
    scotty text wai
  ];
  preConfigure = "hpack";
  homepage = "https://github.com/srdqty/scotty-bytestring#readme";
  description = "ByteString versions of some Scotty functions";
  license = stdenv.lib.licenses.bsd3;
}
