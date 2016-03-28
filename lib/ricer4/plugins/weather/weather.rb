module Ricer4::Plugins::Weather
  class Weather < Ricer4::Plugin

    trigger_is :weather
    
    has_setting name: :api_key, type: :secret, scope: :bot, permission: :responsible, default: '09170f282850fef341148b9903d2ffde'

    has_usage '<..message..>'
    def execute(input)
      threaded { 
        url = "http://api.openweathermap.org/data/2.5/weather?q=#{URI::encode_www_form_component(input)}&units=metric&lang=#{best_owm_lang}&APPID=#{get_setting(:api_key)}"
        data = Net::HTTP.get(URI.parse(url))
        json = JSON.parse!(data)
        if json["cod"].to_i != 200
          rply :err_location
        else
          rply(:msg_openweather,
            city: json["name"],
            country: json["sys"]["country"],
            temp_avg: human_fraction(json["main"]["temp"]),
            temp_min: human_fraction(json["main"]["temp_min"]),
            temp_max: human_fraction(json["main"]["temp_max"]),
          )
        end
      }
    end
    
    OWM_LOCALES ||= [:en, :ru, :it, :es, :uk, :de, :pt, :ro, :pl, :fi, :nl, :fr, :bg, :se, :zh_tw, :zh, :tr, :hr, :ca]
    
    def best_owm_lang
      if OWM_LOCALES.include?(sender.locale.iso.to_sym)
        sender.locale.iso
      else
        :en
      end
      # TODO: Map the best choice for users locale
      # AVAILABLE IN OWM:
      # English - en, Russian - ru, Italian - it, Spanish - es (or sp)
      # Ukrainian - uk (or ua), German - de, Portuguese - pt, Romanian - ro,
      # Polish - pl, Finnish - fi, Dutch - nl, French - fr, Bulgarian - bg
      # Swedish - sv (or se), Chinese Traditional - zh_tw, Chinese Simplified - zh (or zh_cn)
      # Turkish - tr, Croatian - hr, Catalan - ca 
#      "de"
    end
    
  end
end
