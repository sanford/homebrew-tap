class Lshn < Formula
  desc "Terminal Hacker News reader: stories, articles and comments on one screen"
  homepage "https://github.com/sanford/lshn"
  url "https://github.com/sanford/lshn/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "77743045b776b833eac168133f052ae22dd2ada17b7b1b04e1425f96667c518f"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lshn.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lshn-0.3.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b281db6ce67e4ef477e7d4c725ac0568d23dc8ed871b3cd55252d46d4b1310c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "939111859fbd8797fc6c4b027bb0f084911b5a2b626c446ecf3dfed0ca12dbd3"
    sha256 cellar: :any,                 x86_64_linux:  "3cc17cf57b7c2681d4a16b510d4623e0f2260f9c819a10e3d20c6b383cbee1bf"
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
