class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "a7d3284ceb59f9494c80607f42922b3d8af456d4e342dd40cf106c02567c96a1"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c4c389a43b383880d8de0f0e86abb831c470ebe48dd1a9f3ca285a82b4bac39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c565be1d01b01d4326c49ba9c3f4e92d8847889dd47988a84d389bbe647fd26"
    sha256 cellar: :any,                 x86_64_linux:  "5342efdc8d2c313371423664eabdd4386d7c34c6f1225be7d9591bbb6cfb5a29"
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
      url "https://github.com/sanford/lsnet/releases/download/v0.9.0/lsnet-macos-arm64.tar.gz"
      sha256 "f44c41676018a0a090cfd7b82fcee556f1487f22dc4b4950e8d192e81c4ddd6b"
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
