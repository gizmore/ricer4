module Ricer4::Plugins::Email
  class Send < Ricer4::Plugin
    
    trigger_is "mail"

    def upgrade_1
      unless ActiveRecord::Base.connection.column_exists?(Ricer4::User.table_name, :email)
        m = ActiveRecord::Migration
        m.add_column Ricer4::User.table_name, :email, :string, :length  => 128, :null => true, :default => nil, :after => :name
      end
    end

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
