require 'spec_helper'

module Ricer4::Plugins::Test
  class Settings < Ricer4::Plugin
    has_setting name: :test, scope: :bot,     type: :integer, default: 11
    has_setting name: :test, scope: :server,  type: :integer, default: 12
    has_setting name: :test, scope: :channel, type: :integer, default: 13
    has_setting name: :test, scope: :user,    type: :integer, default: 14, min: 10, max: 20
    trigger_is :test_settings
    has_usage ''
    def execute
      value = get_setting(:test)
      reply value
    end
  end
end

describe Ricer4::Bot do
  
  USERS = Ricer4::User
  SERVERS = Ricer4::Server
  CHANNELS = Ricer4::Channel

  bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
  bot.db_connect
  ActiveRecord::Magic::Update.install
  ActiveRecord::Magic::Update.run
  bot.load_plugins
  ActiveRecord::Magic::Update.run

  it("can truncate all tables") do
    USERS.destroy_all
    CHANNELS.destroy_all
  end
  
  it("can execute the echo command") do
    expect(bot.exec_line("echo 4 + 2")).to eq("4 + 2")
  end
  
  it("can decorate plugins with settings") do
    expect(bot.exec_line_for("Test/Settings")).to eq("11")
    expect(bot.exec_line_for("Conf/Conf", "Test/Settings")).to eq("msg_overview:{\"trigger\":\"test_settings\",\"vars\":\"test(11), plugin_enabled(1)\"}")
    expect(bot.exec_line_for("Conf/Conf", "Test/Settings test")).to start_with("msg_show_var:")
    expect(bot.exec_line_for("Conf/ConfUser", "Test/Settings")).to start_with("msg_overview:{\"trigger\":\"test_settings\",\"vars\":\"test(14)\"}")
    expect(bot.exec_line_for("Conf/ConfUser", "Test/Settings test")).to start_with("msg_show_var:{\"trigger\":\"test_settings\",\"varname\":\"test\",\"values\":\"u=14 = 14")
    expect(bot.exec_line_for("Conf/ConfUser", "Test/Settings test 1")).to start_with("err_invalid_value:")
    expect(bot.exec_line_for("Conf/ConfUser", "Test/Settings test 18")).to start_with("msg_saved_setting:")
    expect(bot.exec_line_for("Test/Settings")).to eq("18")
  end
  
end
