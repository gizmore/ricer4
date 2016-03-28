module Ricer4::Include::ProcessorPlugin
  def triggered_line(message)
    line = message.line
    to = message.to_channel? ? message.channel : message.server
    if to.get_triggers.include?(line[0])
      line.ltrim(line[0])
    elsif message.to_query?
      line
    else
      nil
    end
  end
end