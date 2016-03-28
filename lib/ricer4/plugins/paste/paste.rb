module Ricer4::Plugins::Paste
  class Paste < Ricer4::Plugin
    
    trigger_is :paste
    permission_is :voice
    
#   has_usage  '<programming_language> <..text..>', function: :execute_with_language
#   def execute_with_language(programming_language)
#   end

    has_usage '<message>'
    def execute(content)
      execute_upload(content)
    end
    
    def execute_upload(content, pastelang='text', title=nil, langkey=:msg_pasted_it)
      send_pastebin(title||pastebin_title, content, content.count("\n"), 'text', langkey)
    end
    
    def pastebin_title
      t :pastebin_title, user: user.name, date: l(Time.now)
    end

    def send_pastebin(title, content, lines, pastelang='text', langkey=:msg_pasted_this)
      threaded do
        begin
          paste = Pile::Gist.new({user_id:user.id}).upload(title, content, pastelang)
          raise Ricer4::ExecutionException.new("No URI") if paste.url.nil? || paste.url.empty?
          rply(langkey,
            url: paste.url,
            title: title,
            size: human_filesize(paste.size),
            count: lines,
          )
        rescue StandardError => e
          rply :err_paste_failed, reason: e.to_s
        end
      end
    end
    
  end
end
