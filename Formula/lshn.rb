class Lshn < Formula
  desc "Terminal Hacker News reader: stories, articles and comments on one screen"
  homepage "https://github.com/sanford/lshn"
  url "https://github.com/sanford/lshn/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "dedfce642d091d79abad9210cb1222d4f6fdf7a790cfac768f020e3fd0fa19e3"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lshn.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lshn-0.6.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cb7f13f8840ada0e85e46770f71590fa8ef18aeab4da8c738cd3db5d3dc6f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07272bc028e3419d4808fcec6af07c658f7a8d9d208474c87d96ae1787d0e7a1"
    sha256 cellar: :any,                 x86_64_linux:  "631141792f03c49ef68b2fc1da0ab8f771e6937fd27117878298714aef46f8c8"
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
