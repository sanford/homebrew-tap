class Lshn < Formula
  desc "Terminal Hacker News reader: stories, articles and comments on one screen"
  homepage "https://github.com/sanford/lshn"
  url "https://github.com/sanford/lshn/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "970e2cfa162465fd7aadbfd52689b44d12e5e19e662c7555e50c0af50ab51362"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lshn.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lshn-0.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22195fd0226163ec93dbc5922e21ef21d8a964a0a2c49981d92ca54812f43653"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ff553f24fd508c50e16627d05b17a7526673e5f5a9f0da4b35819ddd21d08c5"
    sha256 cellar: :any,                 x86_64_linux:  "8d0880604a225639890c77d3e828d8b122612ff7cae7ef539d3700d1ea01f224"
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
