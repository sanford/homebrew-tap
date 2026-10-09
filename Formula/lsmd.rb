class Lsmd < Formula
  desc "Terminal-friendly Markdown (.md) reader built for navigating large projects"
  homepage "https://github.com/sanford/lsmd"
  url "https://github.com/sanford/lsmd/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "62fe76ca7afc11ab9ab2a2c000792b54a5c24adf20c2fba74df5a7565db8df5f"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lsmd.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsmd-0.9.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7762b6acf5a3b8676f531b35210079bcc78c0e3d0847e6331485e4e845efa8db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bf1fdc957c26a60fc16ee133410f7d25cdeb3d1ec46eaa17d4361339664599b"
    sha256 cellar: :any,                 x86_64_linux:  "7764c663db0349326774ffd30e7498ce5c6570340287ce0afa8a70767c98c1af"
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
