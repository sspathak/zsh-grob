class GitGrob < Formula
  desc "Interactive git rebase --onto helper for managing stacked PRs"
  homepage "https://github.com/sspathak/zsh-grob"
  url "https://github.com/sspathak/zsh-grob/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e1921172d39768a24229e6113971381cbdbabf3c5f3f557bd4ba23eac7f5873a" # Will be filled in when creating actual release
  license "MIT"

  depends_on "fzf"

  def install
    bin.install "git-grob"
  end

  test do
    system "#{bin}/git-grob", "--help"
  end
end
