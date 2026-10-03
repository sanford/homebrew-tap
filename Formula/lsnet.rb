class Lsnet < Formula
  desc "Fast, zero-config LAN scanner that identifies what each device is"
  homepage "https://github.com/sanford/lsnet"
  url "https://github.com/sanford/lsnet/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "225b2607da74b3ddab44ed4c0605cc8c5297e948aa486a7c561515b882b06be6"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lsnet.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsnet-0.6.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a0901043720954e7436b55be0044107f7c767411561088502a2e418ab71bf03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32fedceea53012f7f915c56f6c055f1481b2c598f3110d9fbebfe188af8b5895"
    sha256 cellar: :any,                 x86_64_linux:  "7c7cb6e2e84a89aaf5ffc58bb214e312e49d1d6a5c095993e77b6413e0aa147b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
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
