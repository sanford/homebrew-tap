class Lsmd < Formula
  desc "Terminal-friendly Markdown (.md) reader built for navigating large projects"
  homepage "https://github.com/sanford/lsmd"
  url "https://github.com/sanford/lsmd/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "1b3780a6ad438d36531f5abdf86d227d99ee1bb1a23b90a1bbf94623c148ece0"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lsmd.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsmd-0.9.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26671e6287768bf71564e7a9a9c92fc782cbfc57fc178dc38de3c5c1ec301e2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f0fb45089805f5b84b335319cbceadc00706b004e9e19a8260d5c95fa5997d8"
    sha256 cellar: :any,                 x86_64_linux:  "79c9d5ba6eb29dc9af88c8de1587a66b03db7131661a9ae90453c35c8a4679d6"
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
