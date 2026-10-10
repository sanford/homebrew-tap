class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "4cbb381e03b4c5c240c4a5b4babdaae816c517f236352b3fa4c0fd63626836ae"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.14.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eba305cd9fa788032dd0025e1bbf1b583e0f072f3137042dc34f6c01f4af8e2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc678248e6600348556d959e51307ac18998947e2e7696ec2549f8be7bfccaff"
    sha256 cellar: :any,                 x86_64_linux:  "701b4a3aae601664743a5174b8a19c5b71d08b077f86c79fc7b0454c7bd22a71"
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
      url "https://github.com/sanford/lsnet/releases/download/v0.14.0/lsnet-macos-arm64.tar.gz"
      sha256 "a6bb43d1566dea2fe2f62375898292f9944e0bf7407639d5a08fd76f87ef977c"
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
