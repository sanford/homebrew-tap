class Lsmd < Formula
  desc "Terminal-friendly Markdown (.md) reader built for navigating large projects"
  homepage "https://github.com/sanford/lsmd"
  url "https://github.com/sanford/lsmd/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "137c1b49d22581f305f67f98e2fd49931a789bb8f08484b9ba90812b51930c72"
  license "GPL-3.0-or-later"
  head "https://github.com/sanford/lsmd.git", branch: "main"

  bottle do
    root_url "https://github.com/sanford/homebrew-tap/releases/download/lsmd-0.8.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c59bbae0baa4c1efbb26e44fd5aaca124504b1598dae117a8a2078b66ecb8d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "667f6056b855c68657283e2d2ab9cc4fdd4792110fe9a567c2e1ae2a99edbc1f"
    sha256 cellar: :any,                 x86_64_linux:  "be8de3266e2a69103164dab99ef3584607edd0cad14f23665bd72adb0d5c9665"
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
