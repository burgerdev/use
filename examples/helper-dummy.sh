#!/bin/sh

# This helper installs a program that prints its version.

set -u

cat <<EOF
#!/bin/sh
echo "$1"
EOF
