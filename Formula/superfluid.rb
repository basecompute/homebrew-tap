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
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.13/superfluid-aarch64-apple-darwin.tar.gz"
      sha256 "2077e67f791a9c869a0807d50bec8c18b3c17dbed92189f2bbb3d712b74215ae"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.13/superfluid-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "00b7f07cf8fe8d36fe584edffc78bd700c7f035c020cf45c463d7fa452e5dd4e"
    end
    if Hardware::CPU.arm?
      url "https://github.com/basecompute/superfluid/releases/download/v0.1.13/superfluid-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7d6187c5ad3def620280d2989e55954caab98af6d7c0a32af27285bd7481a16f"
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
