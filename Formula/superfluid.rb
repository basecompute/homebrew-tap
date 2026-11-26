# Written by superfluid's publish workflow (packaging/homebrew/formula.py in
# basecompute/superfluid) for each release; a change made here is overwritten.
class Superfluid < Formula
  desc "Local AI server for distributed LLM inference"
  homepage "https://superfluid.sh"
  license "Apache-2.0"

  # One prebuilt release per platform; Homebrew reads the version from the url.
  # (Each url sits under a CPU check: Homebrew's style rules allow none directly
  # in on_macos / on_linux.)
  on_macos do
    depends_on arch: :arm64
    depends_on macos: :sequoia
    if Hardware::CPU.arm?
      url "https://github.com/basecompute/superfluid/releases/download/v0.2.2/superfluid-aarch64-apple-darwin.tar.gz"
      sha256 "a732b029def68933c6ae994b8cb37ecfc9858ad15053680012afc1382a52ffe3"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/basecompute/superfluid/releases/download/v0.2.2/superfluid-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0cdb469ae5aadc78e969b314607a298c2a440a3bb1d53d70df49264c02e59828"
    end
    if Hardware::CPU.arm?
      url "https://github.com/basecompute/superfluid/releases/download/v0.2.2/superfluid-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dfe6576a4dacb2f1d301fbc667384b4702930ef921fdc1741331883422424906"
    end
  end

  def install
    # The release keeps its layout in libexec: superfluid finds its runtime
    # workers in libexec/superfluid beside its own bin/, through the links below.
    libexec.install "bin", "libexec", "compat.json"
    # Tells `superfluid self update` that Homebrew owns this copy.
    (libexec/"installed-by").write "Homebrew: brew upgrade superfluid\n"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "superfluid #{version}", shell_output("#{bin}/superfluid --version")
    # The shipped runtime workers are found beside the real binary.
    assert_match libexec.to_s, shell_output("#{bin}/superfluid runtimes --json")
  end
end
