{ stdenv
, lib
, fetchFromGitLab
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "pks-openpgp-card";
  version = "005036b0222208debfd142d2fc5ad63f09225617";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "pks-openpgp-card";
    rev = version;
    sha256 = "sha256-TksVdbUM8+nJcxOMmbw8ZBkzXSJHzxoy0T7tu5ijoPk=";
  };

  cargoSha256 = "sha256-IzfRF48k00I+3PXzJTrz4txaEuHAM2uq0h+dp3mu2pQ=";

  doCheck = true;

  meta = with lib; {
    description = "OpenPGP Card store";
    homepage = "https://gitlab.com/sequoia-pgp/pks-openpgp-card";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.lgpl2Plus;

    # error[E0308]: mismatched types
    #    --> /private/tmp/nix-build-pks-openpgp-card-005036b0222208debfd142d2fc5ad63f09225617.drv-0/pks-openpgp-card-005036b0222208debfd142d2fc5ad63f09225617-vendor.tar.gz/openpgp-card-pcsc/src/lib.rs:327:13
    #     |
    # 327 |             u32::from_be_bytes(verify_ioctl) as u64,
    #     |             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ expected `u32`, found `u64`
    #     |
    # help: you can convert a `u64` to a `u32` and panic if the converted value doesn't fit
    #     |
    # 327 |             (u32::from_be_bytes(verify_ioctl) as u64).try_into().unwrap(),
    #     |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # error[E0308]: mismatched types
    #    --> /private/tmp/nix-build-pks-openpgp-card-005036b0222208debfd142d2fc5ad63f09225617.drv-0/pks-openpgp-card-005036b0222208debfd142d2fc5ad63f09225617-vendor.tar.gz/openpgp-card-pcsc/src/lib.rs:428:13
    #     |
    # 428 |             u32::from_be_bytes(modify_ioctl) as u64,
    #     |             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ expected `u32`, found `u64`
    #     |
    # help: you can convert a `u64` to a `u32` and panic if the converted value doesn't fit
    #     |
    # 428 |             (u32::from_be_bytes(modify_ioctl) as u64).try_into().unwrap(),
    #     |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # For more information about this error, try `rustc --explain E0308`.
    # error: could not compile `openpgp-card-pcsc` due to 2 previous errors
    # warning: build failed, waiting for other jobs to finish...
    # error: build failed
    broken = true;
  };
}
