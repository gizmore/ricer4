require 'spec_helper'
describe Ricer4::Bot do
  
  it("loads the plugins") do
    bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
    bot.db_connect
    bot.load_plugins
    bot.install
    bot.upgrade
    bot.exec_line("math 4 + 2")
  end
  
end
