class Lsmd < Formula
  desc "Terminal-friendly Markdown (.md) reader built for navigating large projects"
  homepage "https://github.com/sanford/lsmd"
  url "https://github.com/sanford/lsmd/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "d7cb1032cea7ac845f43e9d17c70ce1f90d85f1c4f278c810760d74248c477b0"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lsmd.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsmd-0.8.3"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a64a84f572e92cda6824b8b6f1b7063a58b9ef8194ede27a7a39feab9cb8d8ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5bd8d5632fcfe882679f9a8c348b90cc403589a6b031e4db9a67c25fee9f2ee"
    sha256 cellar: :any,                 x86_64_linux:  "79e8ef7996d60beca6ee628567f93f6d67108f66ac4d7c575faba38d3eeb5835"
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
