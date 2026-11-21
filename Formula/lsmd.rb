class Lsmd < Formula
  desc "Terminal-friendly Markdown (.md) reader built for navigating large projects"
  homepage "https://github.com/sanford/lsmd"
  url "https://github.com/sanford/lsmd/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "e7c61255a6b2297c7e05b9c55a65bfd17cbdf640e2c2c5a0b3df53cd373726ea"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lsmd.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsmd-0.9.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4e0df49a3d4b4741de1a0c18b5b7aab58771f7a85559720df6a5278c04a0453"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c1b18a774c58064a5baa3937e7247b1e227c9f8c49d3b05f3995dafcf7d45e"
    sha256 cellar: :any,                 x86_64_linux:  "21e5dd1ab4d19ed284134b4a2b65eb3103cf969fd31901b793daf3457d502f99"
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
