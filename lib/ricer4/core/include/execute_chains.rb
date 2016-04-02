module Ricer4::Include::ExecuteChains

  def call_exec_functions(line)
    get_class_variable(:@exec_functions, []).each do |function|
      send(function, line)
    end
  end
  
  def exec_line(line)
    begin
      in_english do
        plugin = bot.loader.get_plugin_for_line!(line)
        plugin.call_exec_functions(line.substr_from(' ')||'')
      end
    rescue => e
      send_exception(e)
    end
  end

end
