module Ricer4::Include::Replies
  
    # This does not respect command chains
    def instant_reply(text, type=Ricer4::Reply::SUCCESS, target=nil)
      current_message.send_reply(Ricer4::Reply.new(text, self, type, target))
    end
  
    # Those all do
    def reply(text); _reply(text, Ricer4::Reply::SUCCESS); end
    def ereply(text); _reply(text, Ricer4::Reply::FAILURE); end
    def areply(text); _reply(text, Ricer4::Reply::ACTION); end
    def nreply(text); _reply(text, Ricer4::Reply::NOTICE); end

    def reply_to(to, text); _reply(text, Ricer4::Reply::SUCCESS, to); end
    def ereply_to(to, text); _reply(text, Ricer4::Reply::FAILURE, to); end
    def areply_to(to, text); _reply(text, Ricer4::Reply::ACTION, to); end
    def nreply_to(to, text); _reply(text, Ricer4::Reply::NOTICE, to); end
    
    def rply(key, args={}); reply t(key, args); end
    def erply(key, args={}); ereply t(key, args); end
    def rplyp(key, args={}); reply tp(key, args); end
    def erplyp(key, args={}); ereply tp(key, args); end
    def rplyr(key, args={}); reply tr(key, args); end

    def arply(key, args={}); areply t(key, args); end
    def arplyp(key, args={}); areply tp(key, args); end
    def arplyr(key, args={}); areply tr(key, args); end

    def nrply(key, args={}); nreply t(key, args); end
    def nrplyp(key, args={}); nreply tp(key, args); end
    def nrplyr(key, args={}); nreply tr(key, args); end
    
    def reply_exception(e)
      if e.is_a?(Ricer4::SilentCancelException)
      elsif(e.is_a?(Ricer4::ExecutionException) ||
            e.is_a?(ActiveRecord::RecordInvalid) ||
            e.is_a?(ActiveRecord::RecordNotFound))
        ereply e.to_s
      else
        bot.log.exception(e)
        ereply(exception_message(e))
      end
    end
    
    def send_exception(e, allow_mail=true)
      bot.log.exception(e, allow_mail)
      responsible = Ricer4::Permission::RESPONSIBLE.bits
      Ricer4::User.online.where("permissions >= #{responsible}").each do |user|
        user.localize!.send_message(exception_message(e), self, Ricer4::Reply::FAILURE)
      end
    end
    
    private
    
    def _reply(text, type, target=nil); current_message.add_reply_with(text, self, type, target); end

    #################
    ### Exception ###
    #################
    def exception_message(e)
      tt('ricer4.err_exception', :message => e.message, :location => short_reply_backtrace(e))
    end
    
    def short_reply_backtrace(e)
      trace = reply_backtrace(e)
      location = trace.substr_from('ricer')
      location.nil? ? trace : 'ricer' + location
    end
    
    def reply_backtrace(e)
      plugin_dir = self.plugin_dir
      # First choice would be a ricer4 or sameplugin file
      e.backtrace.each{|line| return line if line.index('/ricer4/') || line.index(plugin_dir) }
      # Not a ricer problem?
      e.backtrace[0]
    end
  
end
