class Ricer4::HTTPException < Ricer4::RuntimeException
  attr_reader :response
  def initialize(url, esponse=nil)
    @url = url
    @response = response
  end
  def message
    byebug
    if @response
      I18n.t('ricer4.err_response_bad', url: @url, code: response.code, text: response.text)
    else
      I18n.t('ricer4.err_response_empty', url: @url)
    end
  end
end

class Ricer4::HTTPRequestException < Ricer4::HTTPException
  def initialize(url, reason=nil)
    @url = url
    @reason = reason || I18n.t("ricer4.err_reason_unknown")
  end
  def message
    I18n.t("ricer4.err_request_exception", url: @url, reason: @reason)
  end
end

class Ricer4::HTTPRedirectLoopException < Ricer4::HTTPException
  def initialize(url)
    @url = url
  end
  def message
    I18n.t('ricer4.err_redirect_loop', url: @url)
  end
end
