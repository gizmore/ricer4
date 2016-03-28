#require "net/http"
#require "uri"

module Ricer4::Plugins::Links
  class Links < Ricer4::Plugin
    
    include Ricer4::Include::UsesInternet
    
    trigger_is 'links'
    priority_is 90
    
    has_subcommands

    has_usage
    def execute
      rply(:msg_stats,
        total_links: 0,
        total_images: 0,
        total_votes: 0,
        total_likes: 0) 
    end
    
    def plugin_init
      arm_subscribe('ricer/messaged') do |message|
        begin
          add_links(message.line) unless message.processed
        rescue => e
          send_exception(e)
        end
      end
    end
    
    def add_links(line)
      if matches = /[^\s]+:\/\/[^\s]+/.match(line)
        matches.to_a.each do |match|
          match.trim!('()') if match.start_with?('(')
          match.trim!('[]') if match.start_with?('[')
          match.trim!('{}') if match.start_with?('{')
          match.rtrim!("])}\x01")
          add_link(match)
        end
      end
    end
    
    def add_link(url)
      service_threaded do
        request_link(url) 
      end
    end
    
    def request_link(url)
      get_request(url) do |response|
        if response && response.code == '200'
          save_link(response) 
        end
      end
    end
    
    def save_link(response)

      mime = response["content-type"].substr_to(";") || response["content-type"] || ''
      
      write_image = false
      
      case mime.substr_to("/")
      when "image"
        title = url.rsubstr_from('/')
        write_image = true
      when "text"
        case mime
        when "text/html"
          title = extract_html_title(response.body)
        when "text/plain"
          title = response.body.substr_to("\n")
        else
          bot.log.error("Woops... weird mime #{mime}")
        end
      else
      end

      entry = Model::Link.create!({
        url: url,
        title: title,
        mime_type: mime,
        user_id: sender.id,
        channel_id: (channel.id rescue nil),
        hash: Ricer4::Hash.sum(response.body)
      })
      
      entry.save_image(response.body) if write_image
      
      broadcast('link/added', entry)
    end
    
    def extract_html_title(html)
      begin
        title = /title *> *([^<]+) */.match(html)[1]
      rescue => e
        begin
          title = /h[1-6] *> *([^<]+) */.match(html)[1]
        rescue => e
          title = ""
        end
      end
      HTMLEntities.new.decode(title) #.force_encoding('UTF-8'))
    end

  end
end
