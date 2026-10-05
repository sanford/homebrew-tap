class Lshn < Formula
  desc "Terminal Hacker News reader: stories, articles and comments on one screen"
  homepage "https://github.com/sanford/lshn"
  url "https://github.com/sanford/lshn/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0d6ebdf338b685f637b439c0e750241fee4b746c46ff2e222eac97eb26d6fe81"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lshn.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lshn-0.5.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bee7a4c0f62fc4effac4bcffc9916c01e4cba18527c44c5253ceef6bedf8a174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7a81599a46e33be462cedd94b6372e55196e4f96ab374e808df02ef903e7da8"
    sha256 cellar: :any,                 x86_64_linux:  "45e8314b9a67b75528909ebc39e239f6d35cb5fcc05d1c10b5c617149f6a89b8"
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
