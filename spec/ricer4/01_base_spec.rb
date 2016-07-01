require 'spec_helper'
describe Ricer4::Bot do
  
  USERS = Ricer4::User
  SERVERS = Ricer4::Server
  CHANNELS = Ricer4::Channel

  bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
  bot.db_connect

  it("loads the plugins and can exec echo") do
    ActiveRecord::Magic::Update.install
    ActiveRecord::Magic::Update.run
    bot.load_plugins
    ActiveRecord::Magic::Update.run
  end
  
  it("can truncate all tables") do
    USERS.destroy_all
    CHANNELS.destroy_all
  end
  
  it("can execute the echo command") do
    expect(bot.exec_line("echo 4 + 2")).to eq("4 + 2")
  end
  
end
