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
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.14/superfluid-aarch64-apple-darwin.tar.gz"
      sha256 "b47ea2978cf7c3869718a94ce122b002d47ba72eec62f4e0bf651978b78b33a0"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.14/superfluid-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2fb652862b0c2916a6e991047c0b2c98dd90a2bd6756523f4916475f800feaef"
    end
    if Hardware::CPU.arm?
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.14/superfluid-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3492b13a90fd10139f080601aba6eddbb5854274ce7088b110e85ca6d383b7f9"
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
