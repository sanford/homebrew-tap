class Lsmd < Formula
  desc "Terminal-friendly Markdown (.md) reader built for navigating large projects"
  homepage "https://github.com/sanford/lsmd"
  url "https://github.com/sanford/lsmd/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "d1604dcd9ac218a1e25cd246f861e1f9ac64b966e887e9baf4d14addf340a5a9"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lsmd.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsmd-0.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd92fffa242c499208c7f4bfa11a6948718a8a931a704411ec178cf89051dfb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b07a6a49ef6102029ddb561a47518b560fdc9897e1f49cd2f30f163f4d48c0c9"
    sha256 cellar: :any,                 x86_64_linux:  "199c01358ead40a203aa3243ab3cdf49453801e4f2130a3b4bb1fb2ccf751015"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"lsmd", "--completions")
    (man1/"lsmd.1").write Utils.safe_popen_read(bin/"lsmd", "--man")
  end

  test do
    assert_match "lsmd #{version}", shell_output("#{bin}/lsmd --version")
    (testpath/"doc.md").write "# Hello\n\n| a | b |\n|---|---|\n| 1 | 2 |\n"
    output = shell_output("#{bin}/lsmd --plain #{testpath}/doc.md")
    assert_match "Hello", output
    assert_match "│ 1 │ 2 │", output
    assert_match "--edit-config", shell_output("#{bin}/lsmd --completions zsh")
  end
end
