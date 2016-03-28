module Ricer4::Plugins::Quote
  class Announce < Ricer4::Plugin
    
    is_announce_trigger "quote.announce"

    def plugin_init
      arm_subscribe('ricer/quote/added') do |quote|
        announce_quote(quote)
      end
    end

    def announce_quote(quote)
      announce_targets(true) do |target|
        target.localize!.send_message(announce_message(quote))
      end
    end

    def announce_message(quote)
      t(channel ? :msg_announce_channel : :msg_announce_private,
        id: quote.id,
        user: sender.display_name,
        channel: (channel.display_name rescue ''),
        message: quote.message,
      )
    end

  end
end
