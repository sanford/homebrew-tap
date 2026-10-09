class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "70608f5377515ff7e86809993a1b04d3909dd6fbaadf2ac3a1e583f9877394e1"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.10.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f45df5cb132bd44b3bbd8afae7e7276d64d66f954d7fbcccaf63b178ad5c321"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c9cf5a01c4314c62f7a73228a15dec968d65a67898c1a6e59fd45b794ef13e0"
    sha256 cellar: :any,                 x86_64_linux:  "b21c649066296d7641236a209193ab376e2264bec384a29281e5fb0f12be6d6b"
  end

  head do
    url "https://github.com/sanford/lsnet.git", branch: "main"
    depends_on "rust" => :build
  end

  # On Apple silicon, install the release's signed and notarized binary:
  # macOS only shares the ARP table with signed programs, so it sees MAC
  # addresses and silent devices without sudo.
  on_macos do
    on_arm do
      url "https://github.com/sanford/lsnet/releases/download/v0.10.0/lsnet-macos-arm64.tar.gz"
      sha256 "ca3effcceb1ed02c11c0c3d7de5225c32c9b00859b3ad7ffa0c349d3321c4df0"
    end
    on_intel do
      depends_on "rust" => :build
    end
  end

  on_linux do
    depends_on "rust" => :build
  end

  def install
    if OS.mac? && Hardware::CPU.arm? && !build.head?
      bin.install "lsnet"
    else
      system "cargo", "install", *std_cargo_args
    end
  end

  def caveats
    return if OS.mac? && Hardware::CPU.arm? && !build.head?

    <<~EOS
      lsnet works without root. To also see MAC addresses and vendors, and to
      find devices with no open ports, run it with sudo:
        sudo lsnet
    EOS
  end

  test do
    assert_match "lsnet #{version}", shell_output("#{bin}/lsnet --version")
    assert_match "Print results as JSON", shell_output("#{bin}/lsnet --help")
    # A made-up network: no packets sent, nothing written.
    assert_match "Apple TV 4K", shell_output("#{bin}/lsnet --demo --list")
  end
end
