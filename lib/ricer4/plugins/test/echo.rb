module Ricer4::Plugins::Test
  class Echo < Ricer4::Plugin

    version_is 1
    license_is :RICED
    author_is "gizmore@wechall.net"

    trigger_is "echo"

    has_usage "<message>"
    def execute(text)
      reply text
    end

  end
end
