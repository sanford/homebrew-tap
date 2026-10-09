class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b16e1a64b6828a23d70b4504fa2d5f0afbb224d73cf1678415bc3fe5fc96f1af"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.11.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77e41fe2f0559e42c3943ab7d75e8a3eb4118c9a01b376002c7a453136151c14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bfeeb99d292bec7f3af0f29c583182d8bb44ede1e86260f5f468dda0a058c1e"
    sha256 cellar: :any,                 x86_64_linux:  "7f9a8a97050b9ecf2c83e216f5e10869295a330422afda548cd851d93e1ff5f6"
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
      url "https://github.com/sanford/lsnet/releases/download/v0.11.0/lsnet-macos-arm64.tar.gz"
      sha256 "0b4767c1ad178ce34e26fe5e2cc9300e05af64ea6fa932f15763d4e53f0aa549"
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
