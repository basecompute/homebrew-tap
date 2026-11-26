# basecompute/homebrew-tap

Homebrew formulae for Base Compute's tools. `brew install basecompute/tap/<formula>`
adds this tap on first use, so no separate `brew tap` step is needed.

## Install

basert, the baseRT CLI and engine (fast local LLM inference on Apple Silicon and
NVIDIA GB10 / DGX Spark):

```sh
brew install basecompute/tap/basert
```

superfluid, the serving daemon for local LLM inference across runtimes and
machines:

```sh
brew install basecompute/tap/superfluid
```

## Upgrade

```sh
brew update && brew upgrade basert superfluid
```

From basert 0.5.5 and superfluid 0.2.2, a copy in a Homebrew that is yours
updates itself. Once a release is out, a command run in a terminal starts
`brew upgrade basert` (or `brew upgrade superfluid`) in the background and
says so in one line, with the release notes. For basert that is a command
that does something, such as `serve`, `chat`, `pull` or `convert` (not
`list`, `inspect`, `verify`, `self` or `superfluid`); for superfluid it is
`serve`, `launch`, `node`, `top` or `runtime install|update|repair|remove|use`.
A command run with `--json` or `--help` updates nothing. To let a release be
out a while first, `basert self auto-update wait <days>` or `superfluid self
auto-update wait <days>` waits that many days after it is published (0, the
default: none; `BASERT_UPDATE_WAIT_DAYS` or `SUPERFLUID_UPDATE_WAIT_DAYS` for a
shell, a service), and the release found is the newest that has been out that
long.

```text
Updating superfluid 0.2.2 → 0.2.3 with Homebrew in the background (log: /Users/you/.superfluid/logs/auto-update.log) · release notes: … · turn off: superfluid self auto-update off
```

- basert runs it once that command is done, with `HOMEBREW_NO_AUTO_UPDATE`
  set, and only when the formula Homebrew already has is the release it found;
  otherwise the log says so and the upgrade is left to you. While a server
  runs on its engine it runs nothing, and the next command without one tries
  again. Its log is `auto-update.log` in basert's state directory
  (`$BASERT_STATE_DIR` when set, else `serve` beside the model cache:
  `~/Library/Caches/baseRT/serve` on macOS, `~/.cache/baseRT/serve` on Linux,
  or beside `$BASERT_MODELS_DIR` when that is set). A command that does not
  start basert's own update also brings the superfluid `basert serve` runs,
  which basert downloads for itself (in `~/Library/Application
  Support/baseRT/superfluid` on macOS, `~/.local/share/baseRT/superfluid` on
  Linux; not the `superfluid` formula), to a newer release that serves its
  engine, in the foreground with a progress bar; `basert superfluid install
  <version>` goes back.
- superfluid waits until nothing runs from the copy, a server included (for up
  to seven days), then runs it with `HOMEBREW_NO_AUTO_UPDATE` set, and only
  when the formula Homebrew already has is the release it found; otherwise the
  log says so and it tries again a day later. Its log is
  `~/.superfluid/logs/auto-update.log` (`$SUPERFLUID_HOME/logs`).

A pinned formula (`brew pin`) or another user's Homebrew is left alone: you get
a line naming `brew upgrade <formula>` instead (a pinned formula needs `brew
unpin <formula>` first). Nothing updates without a terminal or with `CI` set,
and basert run as root updates nothing.

To turn it off: `basert self auto-update off` or `superfluid self auto-update
off` (from then on; `on` turns it back on; a daily line still says when a newer
release is out), `BASERT_NO_UPDATE=1` or `SUPERFLUID_NO_UPDATE=1` (a shell, a
service), or `--no-update` on any command (that run); the last two turn off
the daily look and the line as well. `brew upgrade` by hand works as before
either way, and `basert self update` / `superfluid self update` run it for
you, asking first.

## Platforms

- basert: Apple Silicon Macs on macOS 15 or newer, and Linux arm64 machines
  with an NVIDIA GPU (GB10 / DGX Spark) and the CUDA 13 runtime.
- superfluid: Apple Silicon Macs on macOS 15 or newer, and Linux on x86_64 or
  arm64.

The basert launcher is Apache-2.0; the engine binaries it drives are under the
BaseRT Engine licence shipped in the bundle. See https://docs.basecompute.co
and https://superfluid.sh.
