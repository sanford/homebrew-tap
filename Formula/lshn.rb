class Lshn < Formula
  desc "Terminal Hacker News reader: stories, articles and comments on one screen"
  homepage "https://github.com/sanford/lshn"
  url "https://github.com/sanford/lshn/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "49e774e84faf661270119a1b44378e40ccc7645038836cb5b37299af9bedb3ee"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lshn.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lshn-0.3.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c89858316c5b2e6d516d7fbe38eb33d9c5cf775a3d0ad8f00dab96df1781d124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34582d5ab194730e23fc3658ee8a9bb5cdf499e9b9105fd3448734703c8f3bd1"
    sha256 cellar: :any,                 x86_64_linux:  "ebfe4acb19dd20874d7d57bbb344f13f6ea9398e560bed0fc12716b991f080c3"
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
