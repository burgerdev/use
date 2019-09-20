# use CLI

This simple program allows switching between versions of an installed binary.
Assuming you have binaries `kubectl-1.13.4` and `kubectl-1.14.1` installed,
`use` can create a symlink `kubectl` to one of them by invoking it as

```sh
use kubectl 1.14.1
```

The eligible binaries are taken from and installed to the directory
`$HOME/.local/bin` by default. This behaviour can be adjusted with the
environment variables `USECLI_BIN_DIR` and `USECLI_TARGET_DIR`, respectively.

# get CLI

This program invokes registered helpers to obtain a binary suitable for `use`.

```sh
get kubectl 1.14.1
```

Helpers are binaries in `GETCLI_HELPER_DIR` (default: `$HOME/.local/bin`) that
match the pattern `get-<base name>`. They read the version number from the
first command line argument and write the binary to stdout. Examples can be
found in the [examples](examples) directory. Binaries will be installed to
`USECLI_BIN_DIR`.
