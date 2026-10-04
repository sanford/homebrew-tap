class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "587dcea01c38f4a1a88b591aa0949710f513b15dca56fb086fb09637a3de3bf3"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.7.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fcbb74743045bd7664977616f8569168df757615345755adf946022555f2752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99605941a4f51d5989d3d40566bb2e1bcc9f5c6f363de38aace968ea1d3ea8cc"
    sha256 cellar: :any,                 x86_64_linux:  "a99ec4cfa8ccff0c489d08accebb70bdb39258b02771d5020f9955bf25a5f2cf"
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
      url "https://github.com/sanford/lsnet/releases/download/v0.7.0/lsnet-macos-arm64.tar.gz"
      sha256 "7ea72d6fe8514fb2c1d6eeb9a79afec988631c4a4c5483613dfb4bebb9c6eeb6"
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
  end
end
