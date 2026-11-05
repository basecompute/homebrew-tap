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
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.9/superfluid-aarch64-apple-darwin.tar.gz"
      sha256 "581ea84f6eee957ee907ae0085714a51d076f6203588906985ca3af4667d8789"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.9/superfluid-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f1cb33b2b3182098d787eeccce05b9f6c9d1ab288b23af9bd9f7bb690c66bf8d"
    end
    if Hardware::CPU.arm?
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.9/superfluid-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "74f5f762eb3ab95184e05dc00629436f0fc8c7531ff3d8277a0e512a115baebf"
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
