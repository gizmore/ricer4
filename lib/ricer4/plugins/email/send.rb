module Ricer4::Plugins::Email
  class Send < Ricer4::Plugin
    
    trigger_is "mail"

    has_usage '<user> <message>', function: :execute_user
    def execute_user(user, message)
      return erply :err_user_has_no_mail unless user.email
      send_mail(user.email, subject, body(message))
      rply :msg_sent, :address => user.display_name
    end

    has_usage '<email> <message>'
    def execute(email, message)
      send_mail(email.address, subject, body(message))
      rply :msg_sent, :address => email.address
    end
    
    def subject
      "sub"
    end
    
    def body(message)
      message
    end
    
  end
end
