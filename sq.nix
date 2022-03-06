{ stdenv
, lib
, fetchFromGitLab
, rustPlatform
, nettle
, openssl
, sqlite
, llvmPackages
, pkg-config
, capnproto
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sq";
  version = "0.26.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia";
    rev = "sq/v${version}";
    sha256 = "sha256-oRxtj8y8QIcgSGwU253WQsmAs9sGCwT4z7BffnTYi+U=";
  };

  cargoSha256 = "sha256-w97EZ7sbRu4dfxiGlLL5EiwxKhHTBM5BrwczUZAfV/4=";
  buildAndTestSubdir = "sq";

  buildInputs = [
    nettle
    openssl
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  nativeBuildInputs = [
    llvmPackages.clang
    pkg-config
    capnproto
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  doCheck = true;

  meta = with lib; {
    description = "Command-line frontends for Sequoia";
    homepage = "https://sequoia-pgp.org/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2Plus;
  };
}
