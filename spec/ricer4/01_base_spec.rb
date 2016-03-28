require 'spec_helper'
describe Ricer4::Bot do
  
  it("connects to the database") do
    bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
    bot.db_connect
  end

  it("installs the ricer4 database") do
    bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
    bot.db_connect
    bot.install
    bot.upgrade
  end

  it("loads the plugins") do
    bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
    bot.db_connect
    bot.load_plugins
    bot.install
    bot.upgrade
  end

  it("starts the main loop") do
    bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
    bot.db_connect
    bot.load_plugins
    bot.step
  end

  it("executes plugins") do
    bot.exec_line("math 4 + 2")
  end
  
end
