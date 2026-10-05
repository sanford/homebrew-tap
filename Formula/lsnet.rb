class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "9ec9b6f3b75caac100b68b3ba5aea5013c24d2abcbb277eaee8767ab555466f8"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.8.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a28995d1f59c828976d8e4044f27a5db1e2ad7254305540e6266215a879b7360"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17953d1b7122595edc73e08f615a6ab94f607981b73da6f45547e4bd1ec1116c"
    sha256 cellar: :any,                 x86_64_linux:  "0f06b8ace86ac7920821507a4c09fea63dab7f8788a20497dd99024e60cac3d0"
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
      url "https://github.com/sanford/lsnet/releases/download/v0.8.0/lsnet-macos-arm64.tar.gz"
      sha256 "1c2c8b8f0b6013a8ef015c907ffaca2bec819ef9c94fc762876b61fe88a95d32"
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
