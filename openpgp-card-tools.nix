{ stdenv
, lib
, fetchFromGitLab
, rustPlatform
, pkg-config
, llvmPackages
, nettle
, pcsclite
, PCSC
}:

rustPlatform.buildRustPackage rec {
  pname = "openpgp-card-tools";
  version = "0.2.1";

  src = fetchFromGitLab {
    owner = "hkos";
    repo = "openpgp-card";
    rev = version;
    sha256 = "sha256-qa3WDSjvLzeU+ZfPGpM+AbrYj3ZciQcPTOcVEM7wkfc=";
  };

  #cargoSha256 = lib.fakeSha256;
  cargoLock.lockFile = ./openpgp-card-Cargo.lock;
  postPatch = ''
    cp ${./openpgp-card-Cargo.lock} ./Cargo.lock
  '';

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  buildAndTestSubdir = "tools";

  buildInputs = [
    nettle
    pcsclite
  ] ++ lib.optionals stdenv.isDarwin [
    PCSC
  ];

  nativeBuildInputs = [
    llvmPackages.clang
    pkg-config
  ];

  doCheck = true;

  meta = with lib; {
    description = "OpenPGP card tools";
    homepage = "https://gitlab.com/hkos/openpgp-card";
    platforms = platforms.linux ++ platforms.darwin;
    licenses = [ licenses.mit licenses.asl20 ];
  };
}
