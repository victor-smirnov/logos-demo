#!/usr/bin/env bash
# Regenerate lforge.hermes by scanning src/<name>/<name>.logos.
#
# Convention: each showcase is a directory src/<name>/ whose entry file is
# <name>.logos (target name == directory name == entry-file basename). Extra
# helper .logos files may live alongside the entry file; they compile into the
# same target. This naming is what makes the VSCode tasks/launch configs
# prompt-free (they key off ${fileBasenameNoExtension}).
#
# Run after adding/removing a showcase. `new-showcase.sh` calls it for you.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

targets=()
for dir in src/*/; do
    name=$(basename "$dir")
    [ -f "src/$name/$name.logos" ] || continue
    targets+=("        { kind: \"bin\", name: \"$name\", src: \"src/$name\", entry: \"$name\" }")
done

if [ ${#targets[@]} -eq 0 ]; then
    echo "sync-manifest: no showcases found under src/<name>/<name>.logos" >&2
    exit 1
fi

{
    # NOTE: the Hermes manifest parser rejects // and /* */ comments, so this
    # file carries no header. It is generated — edit showcases under src/ and
    # re-run scripts/sync-manifest.sh rather than hand-editing targets here.
    echo '{'
    echo '    name:    "logos-demo",'
    echo '    version: "0.1.0",'
    echo '    targets: ['
    # join target lines with ",\n"
    printf '%s' "${targets[0]}"
    for ((i = 1; i < ${#targets[@]}; i++)); do
        printf ',\n%s' "${targets[i]}"
    done
    printf '\n'
    echo '    ]'
    echo '}'
} > lforge.hermes

echo "sync-manifest: wrote lforge.hermes with ${#targets[@]} target(s)"
