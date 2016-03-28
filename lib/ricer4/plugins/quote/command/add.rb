module Ricer4::Plugins::Quote
  class Add < Ricer4::Plugin

    trigger_is "quote.add"

    has_usage '<message|named:"cite">', permission: :voice
    def execute(text)
      quote = Entity.create!({ user: sender, channel: channel, message: text })
      rply :msg_added, :quote_id => quote.id
      arm_publish('ricer/quote/added', quote)
    end

  end
end
