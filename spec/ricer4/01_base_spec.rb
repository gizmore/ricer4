require 'spec_helper'
describe Ricer4::Bot do
  
  it("loads the plugins and can exec echo") do
    
    # LOAD
    bot = Ricer4::Bot.new("ricer4.spec.conf.yml")
    bot.db_connect
    ActiveRecord::Magic::Update.install
    ActiveRecord::Magic::Update.run
    bot.load_plugins
    ActiveRecord::Magic::Update.run

    # Test cases
    expect(bot.exec_line("echo 4 + 2")).to eq("4 + 2")

  end
  
end
