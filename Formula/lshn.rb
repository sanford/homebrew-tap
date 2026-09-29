class Lshn < Formula
  desc "Terminal Hacker News reader: stories, articles and comments on one screen"
  homepage "https://github.com/sanford/lshn"
  url "https://github.com/sanford/lshn/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "314a6f0836f4d5ca07355d65bfb71543aec154d12d7d049fd0fe5b5dce579f52"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lshn.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "lshn #{version}", shell_output("#{bin}/lshn --version")
    assert_match "Read Hacker News in the terminal", shell_output("#{bin}/lshn --help")
  end
end
