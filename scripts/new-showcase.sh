#!/usr/bin/env bash
# Scaffold a new showcase and refresh the manifest.
#
#   scripts/new-showcase.sh <name>
#
# Creates src/<name>/<name>.logos from a template and regenerates lforge.hermes.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

name=${1:-}
if [ -z "$name" ]; then
    echo "usage: scripts/new-showcase.sh <name>" >&2
    exit 2
fi
# lforge identifiers (and package names) are ASCII; keep names tame.
if ! [[ "$name" =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo "new-showcase: name must match [a-z][a-z0-9_]* (got '$name')" >&2
    exit 2
fi

src="src/$name/$name.logos"
if [ -e "$src" ]; then
    echo "new-showcase: $src already exists" >&2
    exit 1
fi

mkdir -p "src/$name"
cat > "$src" <<EOF
package $name;

use logos.std.io;

fn main() -> i32 {
    println("$name showcase");
    return 0;
}
EOF

"$root/scripts/sync-manifest.sh"
echo "new-showcase: created $src"
echo "  build:  lforge build $name"
echo "  run:    lforge run $name"
