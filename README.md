# logos-demo

Various demos and showcases for the Logos programming language, set up as a
single `lforge` project you can edit, build, run, and debug in VSCode or from
the command line.

## Layout

```
logos-demo/
  lforge.hermes          # generated — one bin target per showcase
  src/
    hello/hello.logos    # each showcase: src/<name>/<name>.logos
    strings/strings.logos
  scripts/
    new-showcase.sh      # scaffold a new showcase + sync manifest
    sync-manifest.sh     # regenerate lforge.hermes from src/*/
  .vscode/               # tasks, launch, settings, recommended extensions
  .lforge/               # build output (git-ignored)
```

**Convention:** a showcase is a directory `src/<name>/` whose entry file is
`<name>.logos`. The target name equals the directory name equals the entry-file
basename. This is what lets the VSCode tasks/launch configs be prompt-free —
they key off the open file's basename.

## Command line

The Logos toolchain (`logosc`, `lforge`, `logos-gdb`) is installed system-wide;
`lforge` finds the compiler and stdlib on its own (no env vars needed).

```bash
lforge build              # build all showcases
lforge build hello        # build one
lforge run hello          # build + run one
lforge run strings
lforge clean              # rm -rf .lforge/

scripts/new-showcase.sh foo   # create src/foo/foo.logos, update manifest
scripts/sync-manifest.sh      # rebuild lforge.hermes after manual add/remove
```

Adding/removing a showcase changes `lforge.hermes`; it's generated, so run
`sync-manifest.sh` (or `new-showcase.sh`, which calls it) instead of editing it
by hand. The Hermes manifest parser rejects comments, so the file has none.

## VSCode

Open this folder in VSCode and install the recommended extension
(**ms-vscode.cpptools**, used as the debugger driver).

**Build / run** — Command Palette → *Run Task* (or `Ctrl+Shift+B` for the
default build):

| Task                              | What                                            |
|-----------------------------------|-------------------------------------------------|
| `lforge: build current`           | build the showcase of the active file (default) |
| `lforge: run current`             | build + run the active file's showcase          |
| `lforge: build current (release)` | release profile                                 |
| `lforge: build all`               | build every showcase                            |
| `lforge: test`                    | `lforge test`                                   |
| `lforge: clean`                   | remove `.lforge/`                               |
| `logos-demo: sync manifest`       | regenerate `lforge.hermes`                      |

Build errors are parsed into the Problems panel (logosc text diagnostics).

**Debug** — open a showcase's entry file and press **F5**
(*Debug current showcase*). It builds with `-g` and drops you into `logos-gdb`
with the Logos pretty-printers loaded, so a `String` prints as `"..."`, `Vec`
as a list, etc. The *Debug showcase (pick target)* config prompts for a target
name instead of using the active file.

The debug profile of `lforge build` emits `-g`, so the debug configs build with
lforge directly (the `release` profile does not carry Logos debug info).

### Highlighting

There's no Logos VSCode language extension yet (LSP is on the lforge roadmap).
Logos is Rust-like, so `.vscode/settings.json` maps `*.logos` to Rust's grammar
for syntax highlighting only. If you have rust-analyzer installed and it gets
noisy on `.logos` files, change that association to `plaintext`.
