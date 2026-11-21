class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "b212e0529f94cac7fb6a4f6250de6ced0d95953658aa613933d7fdaad58b5581"
  license "GPL-3.0-or-later"

  head do
    url "https://github.com/sanford/lsnet.git", branch: "main"
    depends_on "rust" => :build
  end

  # On Apple silicon, install the release's signed and notarized binary:
  # macOS only shares the ARP table with signed programs, so it sees MAC
  # addresses and silent devices without sudo.
  on_macos do
    on_arm do
      url "https://github.com/sanford/lsnet/releases/download/v0.15.1/lsnet-macos-arm64.tar.gz"
      sha256 "f30c4b97af9aa589af20dffed5b66606add6f2bd6f85cceef2c0bee2c7d4bbdf"
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
