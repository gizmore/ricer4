module Ricer4::Plugins::Internet
  class Http < Ricer4::Plugin
    
    include Ricer4::Include::UsesInternet
    
    trigger_is "net.http"
    
    has_usage('<url>')
    def execute(url)
      threaded do
        get_request(url.to_s) do |response|
          reply response.body
        end
      end
    end
    
  end
end