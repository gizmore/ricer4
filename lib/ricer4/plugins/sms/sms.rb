module Ricer4::Plugins::Sms
  class Sms < Ricer4::Plugin
    
    has_setting name: :sid,    type: :secret, permission: :responsible, scope: :bot, default: bot.config.twilio_sid
    has_setting name: :phone,  type: :secret, permission: :responsible, scope: :bot, default: bot.config.twilio_number
    has_setting name: :secret, type: :secret, permission: :responsible, scope: :bot, default: bot.config.twilio_secret
    
    trigger_is "sms"
#    has_usage "<user> <message|max:140>", function: :execute_user, permission: :ircop
    has_usage "<phone> <message|max:100>", function: :execute_number, permission: :owner
    
    def sms_client
      Twilio::REST::Client.new(get_setting(:sid), get_setting(:secret))
    end
    
    def execute_number(number, message)
      threaded do
        begin
          sms_client.account.messages.create({
            :from => get_setting(:phone),
            :to => number,
            :body => message
          })
          rply :msg_sent
        rescue Twilio::REST::RequestError => e
          erply :err_send, code: e.code, error: e.message
        rescue Twilio::REST::ServerError => e
          erply :err_server, error: e.message
        end
      end
    end
    
  end
end
