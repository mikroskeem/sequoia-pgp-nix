{ stdenv
, lib
, fetchFromGitLab
, rustPlatform
, pkg-config
, pcsclite
, PCSC
}:

rustPlatform.buildRustPackage rec {
  pname = "pks-openpgp-card";
  version = "753b53c9bdbdb98cd9e57a0a94bd1f15776ecf48";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "pks-openpgp-card";
    rev = version;
    hash = "sha256-ThzOWb0OtVtqFoFA2lbAAYHMzkHo7XgoYn3hGZ+0rus=";
  };

  cargoHash = "sha256-b7mGLzG+Q//3BgrW08qXH26OHnLj9CqPyeWK8Yu2S6w=";

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
