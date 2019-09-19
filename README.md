# Use CLI

This simple program allows switching between versions of an installed binary.
Assuming you have binaries `kubectl-1.13.4` and `kubectl-1.14.1` installed,
`use` can create a symlink `kubectl` to one of them by invoking it as

```
use kubectl 1.14.1
```

The eligible binaries are taken from and installed to the directory
`$HOME/.local/bin` by default. This behaviour can be adjusted with the
environment variables `USECLI_BIN_DIR` and `USECLI_TARGET_DIR`, respectively.
