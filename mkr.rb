# typed: false
# frozen_string_literal: true

# Formula to install mkr CLI tool.
class Mkr < Formula
  desc "CLI tool for https://mackerel.io/"
  homepage "https://github.com/mackerelio/mkr"
  version "0.46.0"
  if Hardware::CPU.arm?
    url "https://github.com/mackerelio/mkr/releases/download/v0.46.0/mkr_darwin_arm64.zip"
    sha256 "2dc4e2bb93abcc6ca3a6e1582cf022ab8df69201f070f260c7849e2a95618063"
  else
    url "https://github.com/mackerelio/mkr/releases/download/v0.46.0/mkr_darwin_amd64.zip"
    sha256 "8e013543b9fc51b0d09bf1cccf4f3a4d3f8e3546c1ec0fed31228b62dc319b55"
  end

  head do
    url "https://github.com/mackerelio/mkr.git", branch: "master"
    depends_on "git" => :build
    depends_on "go" => :build
    depends_on "mercurial" => :build
  end

  def install
    if build.head?
      system "make", "build"
    end
    bin.install "mkr"
  end

  test do
    system "mkr", "--version"
  end
end
