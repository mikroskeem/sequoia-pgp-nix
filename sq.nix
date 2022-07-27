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
  version = "0.27.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia";
    rev = "sq/v${version}";
    hash = "sha256-KhJAXpj47Tvds5SLYwnsNeIlPf9QEopoCzsvvHgCwaI=";
  };

  cargoHash = "sha256-QSO6UmJdHcDy6vzo3MIWvhTeWDDs/SGmhfF47nghbFE=";
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
