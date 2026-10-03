class Lshn < Formula
  desc "Terminal Hacker News reader: stories, articles and comments on one screen"
  homepage "https://github.com/sanford/lshn"
  url "https://github.com/sanford/lshn/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "84aaf900e6d3e06770cdf72eb8872d19f21b82d8fcdc06ed8584a4bcac33b110"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lshn.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lshn-0.3.3"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f27d2c7c6cfcd20664c1723dbab73bdecd248e08f4186f6b5ee434c2b1d623c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7570d4f2dc7b2dc4f117fafe2941b7c54d910ae8b3312b319bf140912eedeaf2"
    sha256 cellar: :any,                 x86_64_linux:  "8b38d4bc2cfd66b5f07362b7825dd28ec536723238978f6fb4c616d55531b585"
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
