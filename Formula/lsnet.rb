class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "ff1e9f6f2ce1fda8b3b9a20feee05cff589f761ca03ea9101e682dcef9e41523"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.14.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "737e63ba392f391d7b15b431e9993ecc4355d8005ab81d3a5f9e1d2194c531fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a000cf0d47c6f9dc07d697fa699faa2c71b8cbc8c99e8122abba6e02922412c1"
    sha256 cellar: :any,                 x86_64_linux:  "7b7649742bbd631a18a4357b79b322cddd299698bf53b61e070d2bfe8d748713"
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
      url "https://github.com/sanford/lsnet/releases/download/v0.14.1/lsnet-macos-arm64.tar.gz"
      sha256 "7a29208e3dfb5a7886096259cdf55e83f85f66c1ba4ef44c13fbf6afd0ee9876"
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
