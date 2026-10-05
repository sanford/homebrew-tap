class Lshn < Formula
  desc "Terminal Hacker News reader: stories, articles and comments on one screen"
  homepage "https://github.com/sanford/lshn"
  url "https://github.com/sanford/lshn/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0d6ebdf338b685f637b439c0e750241fee4b746c46ff2e222eac97eb26d6fe81"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lshn.git", branch: "main"

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
