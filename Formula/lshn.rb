class Lshn < Formula
  desc "Terminal Hacker News reader: stories, articles and comments on one screen"
  homepage "https://github.com/sanford/lshn"
  url "https://github.com/sanford/lshn/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "c490145816de885184a1c8f01a8acb68edd0b39dfcb7640bcef501cc7758b657"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lshn.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lshn-0.5.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b5b376543c6b0a54448f075fafefb1a0e477dafa6576fd61bb53a2e1a37505a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "554e8b9409fdb73d076c4c7834ef2b69c66e79841f5d431dc17b5d3b6464f7e4"
    sha256 cellar: :any,                 x86_64_linux:  "18146523f56c4db52ea6da1e8e5ea3afc1a1b7b54654853fc705aa467e76070b"
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
