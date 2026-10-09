class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "58e46504783f6709b9e25f887227709eb10531d61897bcdc9b44a4b4aa06a506"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.12.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74caf0f7ebd406949ba8b5705a159300784295c5d68d32b83206d001f2a6ae18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "239b9681ebfb811e8afd537f73d4245435ebba7ff940abbdc8d023a60b5a0ad1"
    sha256 cellar: :any,                 x86_64_linux:  "c1b4bf2cbac7880f8cd3562269c18054b58ceed0131644658d3e9b5a3dca0846"
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
      url "https://github.com/sanford/lsnet/releases/download/v0.12.0/lsnet-macos-arm64.tar.gz"
      sha256 "1feb2f3eeacc81aa7c3c24debd627a54c95c58de76926f7215e7f0c58ffc9638"
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
