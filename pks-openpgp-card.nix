{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, pcsclite
, PCSC
}:

rustPlatform.buildRustPackage rec {
  pname = "pks-openpgp-card";
  version = "e83208de8ff1ac5fc0461fa450b1e867dc3b7638";

  src = fetchFromGitHub {
    owner = "mikroskeem";
    repo = "pks-openpgp-card";
    rev = version;
    sha256 = "sha256-8wsPgd1ZSGWIWZlBR5gnkaqW4O/2mEzgI0A6oGvlzEM=";
  };

  cargoSha256 = "sha256-Z31UROtesXgoAqftDTn9i8l+xH5up8Mj2AuChZaizuI=";

  buildInputs = [
    pcsclite
  ] ++ lib.optionals stdenv.isDarwin [
    PCSC
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  doCheck = true;

  meta = with lib; {
    description = "OpenPGP Card store";
    homepage = "https://gitlab.com/sequoia-pgp/pks-openpgp-card";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.lgpl2Plus;
  };
}
