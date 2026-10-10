class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "11860c2ae5f2b02ee0d9b43a68c695c303265f76d01dba5c44d2e46303f68f2d"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.13.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "853fd3b19d5fced90f7f2a65c2be68dda2610958f06d9e95f32b6419c456753f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21f57888a57df9180dca3247eddb84a69371509178e728f6acae39c53e9a963e"
    sha256 cellar: :any,                 x86_64_linux:  "92fcb14fafc1e442c34385ef36284528dec437f1007055119a1ba191456787c8"
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
      url "https://github.com/sanford/lsnet/releases/download/v0.13.0/lsnet-macos-arm64.tar.gz"
      sha256 "f66d43e2e1018eb793e82f90bce934bda10bb712e063fe4625e220b3f9baad2f"
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
