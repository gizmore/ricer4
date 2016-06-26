##
# Extend ARM to know special BOT and IBDES languages.
# bot: return key as is, with JSON vars if any.
# ibdes: convert some keys and follow IBDES specs. Else behave like bot.
#
# Extend ARM to replace special strings in translated strings, like $BOT$, $T$ and $CMD$.
#
# Disable Language fallback for IBDES and BOT.
#
# 
#
module ActiveRecord::Magic::Translate::Extend
  
  def i18t!(key, args={})
    case I18n.locale
    when :bot; i18t_bot!(key, args)
    when :ibdes; i18t_ibdes!(key, args)
    else; I18n.t!(key, args)
    end
  end
  
  def i18t_bot!(key, args)
    begin
      I18n.t!(key, args)
    rescue
      vars = args.length == 0 ? "" : ":#{args.to_json}"
      "#{key}#{vars}"
    end
  end

  def i18t_ibdes!(key, args)
    i18t_bot!(key, args)
  end
  
  def rt(response)
    response.to_s.
      gsub('$BOT$', (server.next_nickname rescue 'ricer')).
      gsub('$CMD$', (plugin_trigger.to_s rescue '')).
      gsub('$T$', (server.triggers[0] rescue ''))
  end
  
end