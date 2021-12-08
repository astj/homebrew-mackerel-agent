# typed: false
# frozen_string_literal: true

# Formula to install mackerel-agent.
class MackerelAgent < Formula
  desc "Monitoring agent for https://mackerel.io/"
  homepage "https://github.com/mackerelio/mackerel-agent"
  version "0.72.5"
  if Hardware::CPU.arm?
    url "https://github.com/mackerelio/mackerel-agent/releases/download/v0.72.5/mackerel-agent_darwin_arm64.zip"
    sha256 "518f2d853072ea5e445ada6adc5f5c11506e735d184f152af7529193422508b0"
  else
    url "https://github.com/mackerelio/mackerel-agent/releases/download/v0.72.5/mackerel-agent_darwin_amd64.zip"
    sha256 "f81f48557fa0b51afcbaa6b10176e578bdee63f1a4d21d06bb48720ce342c064"
  end

  head do
    url "https://github.com/mackerelio/mackerel-agent.git", branch: "master"
    depends_on "git" => :build
    depends_on "go" => :build
    depends_on "mercurial" => :build
  end

  def install
    if build.head?
      system "make", "build"
      bin.install "build/mackerel-agent"
      etc.install "mackerel-agent.sample.conf" => "mackerel-agent.conf"
    else
      bin.install "mackerel-agent"
      etc.install "mackerel-agent.conf"
    end
    mkdir_p "#{var}/mackerel-agent"
  end

  def caveats
    <<~EOS
      You must append `apikey = {apikey}` configuration variable to #{etc}/mackerel-agent.conf
      in order for mackerel-agent to work.
    EOS
  end

  plist_options manual: "mackerel-agent -conf #{HOMEBREW_PREFIX}/etc/mackerel-agent.conf"
  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/mackerel-agent</string>
            <string>supervise</string>
            <string>-conf</string>
            <string>#{etc}/mackerel-agent.conf</string>
            <string>-private-autoshutdown</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}/mackerel-agent</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/mackerel-agent.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system "mackerel-agent", "-version"
  end
end
