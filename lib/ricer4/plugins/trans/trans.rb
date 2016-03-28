module Ricer4::Plugins::Trans
  class Trans < Ricer4::Plugin
    
    trigger_is :t

    has_usage  '<lang_iso> <lang_iso|multiple:true> <message>', function: :execute_from
    def execute_from(from_iso, isos, text)
      threaded do
        gtrans = Ricer4::GTrans.new(text, from_iso)
        isos.each do |iso|
          execute_single(gtrans, iso)
        end
      end
    end

    has_usage  '<lang_iso|multiple:true> <message>', function: :execute
    def execute(isos, text)
      execute_from(Ricer4::GTrans::AUTO, isos, text)
    end

    has_usage  '<message>', function: :execute_auto
    def execute_auto(text)
      locale = channel ? channel.locale : user.locale
      execute([locale.iso], text)
    end
    
    private

    def execute_single(gtrans, target_iso)
      trans = gtrans.to(target_iso)
      if trans[:text]
        rply(:msg_translated, from: trans[:iso], to: trans[:target_iso], text: trans[:text])
      elsif (trans[:target_iso] == trans[:iso])
        rply(:err_same, to: target_iso)
      else
        rply(:err_translate, from: trans[:iso], to: trans[:target_iso])
      end
    end
    
  end
end
