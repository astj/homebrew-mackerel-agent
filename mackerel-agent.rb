class MackerelAgent < Formula
  homepage 'https://github.com/mackerelio/mackerel-agent'
  url 'https://github.com/mackerelio/mackerel-agent/releases/download/v0.14.1/mackerel-agent_darwin_386.zip'
  version '0.14.1'
  sha1 '9a0d0fda33af66c0b39239b10800e09357cdf6bc'

  head do
    url 'https://github.com/mackerelio/mackerel-agent.git'
    depends_on 'go' => :build
    depends_on 'git' => :build
    depends_on 'mercurial' => :build
  end

  def install
    if build.head?
      ENV['GOPATH'] = buildpath/'.go'
      mkdir_p buildpath/'.go/src/github.com/mackerelio'
      ln_s buildpath, buildpath/'.go/src/github.com/mackerelio/mackerel-agent'
      system 'make', 'build'
      bin.install 'build/mackerel-agent'
      etc.install 'mackerel-agent.conf'
    else
      bin.install 'mackerel-agent'
      etc.install 'mackerel-agent.conf'
    end
    mkdir_p "#{var}/mackerel-agent"
  end

  test do
    system 'mackerel-agent', '-version'
  end

  plist_options :manual => "mackerel-agent -conf #{HOMEBREW_PREFIX}/etc/mackerel-agent.conf"

  def plist; <<-EOS.undent
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
         <string>-conf</string>
         <string>#{etc}/mackerel-agent.conf</string>
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

  def caveats; <<-EOS.undent
    You must append `apikey = {apikey}` configuration variable to #{etc}/mackerel-agent.conf
    in order for mackerel-agent to work.
    EOS
  end
end
