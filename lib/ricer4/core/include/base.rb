module Ricer4::Include::Base

  def line; current_message.line; end
  def user; current_message.sender; end
  def sender; current_message.sender; end
  def server; current_message.server; end
  def channel; current_message.channel; end
  def current_message; Ricer4::Message.current; end
  def current_command; Ricer4::Command.current; end
  def get_plugin(name); bot.loader.get_plugin(name); end

end
