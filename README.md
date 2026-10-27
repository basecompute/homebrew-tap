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

## Platforms

- basert: Apple Silicon Macs on macOS 15 or newer, and Linux arm64 machines
  with an NVIDIA GPU (GB10 / DGX Spark) and the CUDA 13 runtime.
- superfluid: Apple Silicon Macs on macOS 15 or newer, and Linux on x86_64 or
  arm64.

The basert launcher is Apache-2.0; the engine binaries it drives are under the
BaseRT Engine licence shipped in the bundle. See https://docs.basecompute.co
and https://superfluid.sh.
