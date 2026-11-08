class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "bdfe6a3a60711e9e63ea95c4bebca3bc01ea301e708640e36354f129c9b8c846"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.15.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93f254ff32504ac527f08ef7e941eb1d9811e015cbf4887a06370fb4c3e8375b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471ad6404ee5c3fd8b65d2672a3b6a2d0bdaac48ef77aed90a99d109f2a02cf6"
    sha256 cellar: :any,                 x86_64_linux:  "3c43b6343b9dd4da18f6c8b2a192e6034dbc6ba83314b8a4757ccc2b8e529dfe"
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
      url "https://github.com/sanford/lsnet/releases/download/v0.15.0/lsnet-macos-arm64.tar.gz"
      sha256 "d0792cf473a2d03410d5c9d1aaaccc129f410734009ca316809ca4fed46870c9"
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
