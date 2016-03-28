module Ricer4::Include::UsesInternet
  
  def get_request(url, redirects=10, initial=true, &block)
    begin
      Ricer4::Bot.instance.log.info("UsesInternet.get_request(#{url})") if initial
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request["open_timeout"] = 10
      http.use_ssl = (uri.scheme == "https")
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl?
      response = http.request(request)
      case response
      when Net::HTTPRedirection
        if redirects > 0
          get_request(response['location'], redirects - 1, false, &block)
        else
          raise Ricer4::HTTPRedirectLoopException.new(url)
        end
      else
        yield(response)
      end
    rescue => e
      Ricer4::Bot.instance.log.exception(e)
      raise Ricer4::HTTPRequestException.new(url, e.message)
    end
  end
  
end
