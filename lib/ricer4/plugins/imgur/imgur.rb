# require 'json'
# require 'open-uri'
module Ricer4::Plugins::Imgur
  class Imgur < Ricer4::Plugin

    trigger_is :imgur
    
    denial_of_service_protected
    
    has_usage
    def execute
      imgur("https://api.imgur.com/3/gallery/random/random/")
    end
    
    has_usage  '<message>', function: :execute_msg
    def execute_msg(message)
      case message
      when "hot"; group = "hot"
      when "viral"; group = "viral"
      when "top"; group = "top"
      else; execute; return nil
      end
      page = rand(4)
      imgur("https://api.imgur.com/3/gallery/#{group}/top/#{page}.json")
    end
    
    protected
    
    def imgur(url)
      service_thread {
        uri = open(url,
          "Authorization" => 'Client-ID a90bec0cef5bd5c',
          "Accept" => 'application/json',
        )
        buffer = uri.read
        result = ActiveSupport::JSON.decode(buffer)
        id = rand(7)
        imgur = result['data'][id]
        reply "#{imgur['title']} - #{imgur['link']} \u000303#{imgur['ups']}\u000f\u2934 \u000304#{imgur['downs']}\u000f\u2935"
      }
    end

  end
end
