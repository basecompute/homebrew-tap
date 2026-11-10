# Written by superfluid's publish workflow (packaging/homebrew/formula.py in
# basecompute/superfluid) for each release; a change made here is overwritten.
class Superfluid < Formula
  desc "Serving daemon for local LLM inference across runtimes and machines"
  homepage "https://superfluid.sh"
  license "Apache-2.0"

  # One prebuilt release per platform; Homebrew reads the version from the url.
  # (Each url sits under a CPU check: Homebrew's style rules allow none directly
  # in on_macos / on_linux.)
  on_macos do
    depends_on arch: :arm64
    depends_on macos: :sequoia
    if Hardware::CPU.arm?
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.11/superfluid-aarch64-apple-darwin.tar.gz"
      sha256 "3acab1fedf5270a9bd5f0dea1d3e975c9f0bb0839e73186f9930c1e92f4b1f45"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.11/superfluid-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3a72bf0f68be7291d3c0b6748064bd5a598409f29c9877545b4d8a6539a4abaa"
    end
    if Hardware::CPU.arm?
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.11/superfluid-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d5ce931b16733486b58d94ea2e29195dd4d141e070b17c3c7b4b51f46260e43f"
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
