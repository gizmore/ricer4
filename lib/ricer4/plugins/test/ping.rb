module Ricer4::Plugins::Test
  class Ping < Ricer4::Plugin

    version_is 1
    license_is :RICED
    author_is "gizmore@wechall.net"

    has_setting name: :pongs, type: :integer, scope: :bot, permission: :responsible, default: 0, min: 0

    trigger_is :ping

    def plugin_init
      @count = 0
    end

    has_usage
    def execute
      @count += 1
      rply :msg_pong, count: @count, total: increase_setting(:pongs, :bot)
    end

  end
end