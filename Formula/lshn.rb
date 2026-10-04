class Lshn < Formula
  desc "Terminal Hacker News reader: stories, articles and comments on one screen"
  homepage "https://github.com/sanford/lshn"
  url "https://github.com/sanford/lshn/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "1b2f8203dedc0d0f91807f586dd21a35fb4bcfb6bc173593ffc53fd463dbd701"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lshn.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lshn-0.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82f957218633afda71042057ba2da5d538294a778f62a64f300746b6625f5d1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d202ee82c63b65e99ed65d1e5a4bd011410aae79dc2e01da016a3187d218c384"
    sha256 cellar: :any,                 x86_64_linux:  "9c06cbc9a3b32bea6d8c763da684d84e40f163828d503622ffb51dbb8d1751dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"lshn", "--completions")
    (man1/"lshn.1").write Utils.safe_popen_read(bin/"lshn", "--man")
  end

  test do
    assert_match "lshn #{version}", shell_output("#{bin}/lshn --version")
    assert_match "Read Hacker News in the terminal", shell_output("#{bin}/lshn --help")
  end
end
