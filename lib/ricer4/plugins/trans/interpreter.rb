module Ricer4::Plugins::Trans
  class Interpreter < Ricer4::Plugin
    
    trigger_is :interpreter
    
    priority_is 100
    
    has_setting name: :translating, type: :string, scope: :user,    permission: :responsible, default: "0"
    has_setting name: :translating, type: :string, scope: :channel, permission: :responsible, default: "0"

    # Show status
    has_usage '', function: :execute_status
    def execute_status
      rply(:msg_status, onoff: display_on_off, isos: display_interpreter_isos)
    end

    # Toggle
    has_usage  '<boolean>', function: :execute_toggle
    def execute_toggle(bool)
      return rply :err_no_isos unless has_isos?
      bool ? execute_enable() : execute_disable()
    end
    def execute_enable; save_interpreting('1'); rply(:msg_enabled, isos: display_interpreter_isos); end
    def execute_disable; save_interpreting('0'); rply(:msg_disabled, isos: display_interpreter_isos); end
    def save_interpreting(on_off); save_setting(:translating, interpreter_scope, on_off+get_setting(:translating)[1..-1]); end

    # Configure
    has_usage '<lang_iso|multiple:true>'
    def execute(isos)
      save_setting(:translating, interpreter_scope, '1'+isos.join(','));
      execute_enable
    end

    def plugin_init
      arm_subscribe("ricer/messaged") do |message|
        on_privmsg if message.is_privmsg?
      end
    end

    # Event    
    def on_privmsg
      
      line = current_message.line
      
      # Ignore some messages
      return if line.length < 12
      return if channel && current_message.is_triggered? # Channel commands ignored
      return unless is_interpreting? # Disabled
      return if channel.nil? && plugins_for_line(line).length > 0 # ignore commands

      # Do the interpreter stuff
      threaded do
        gtrans = Ricer4::GTrans.new(line)
        interpreter_isos.each do |iso|
          translate_single(gtrans, iso)
        end
      end
    end
    
    # Private
    private
    # Helper
    def interpreter_scope; channel ? :channel : :user; end
    def is_interpreting?; get_setting(:translating).start_with?('1'); end
    def interpreter_isos; get_setting(:translating)[1..-1].split(','); end
    def has_isos?; isos = interpreter_isos; (isos != nil) && (isos.length > 0); end
    # Display
    def display_on_off; is_interpreting? ? t(:interpreter_on) : t(:interpreter_off); end
    def display_interpreter_isos; has_isos? ? human_join(interpreter_isos) : t(:no_isos_yet); end

    # Actual interpreting
    def translate_single(gtrans, iso)
      trans = gtrans.to(iso)
      text = trans[:text]
      rply(:msg_interpreted, iso: iso, text: text) if text
    end

  end
end
