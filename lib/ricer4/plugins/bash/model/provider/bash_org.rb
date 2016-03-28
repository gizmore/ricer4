module Ricer4::Plugins::Bash
  class BashOrg < Provider
    
    def display_name; 'Bash'; end

    def more_random
      request_bash_page("http://www.bash.org/?random", true)
    end

    def more_latest(high_id)
      if quotes = request_bash_page("http://www.bash.org/?latest", true)
        quotes.select { |quote| quote.cite_id > high_id }
      end
    end

    def get_number(cite_id)
      if quotes = request_bash_page("http://www.bash.org/?#{cite_id}", false)
        quotes.first
      end
    end
    
    def search(term)
      request_bash_page("http://www.bash.org/?search=#{URI::encode_www_form_component(term)}&sort=0&show=25", false)
    end
    
    def request_bash_page(url, only_unknown)
      return get_request(url) do |response|
        if response && response.code == "200"
          ActiveRecord::Base.transaction do
            return parse_bash_page(response, only_unknown)
          end
        end
        return nil
      end
    end
    
    def parse_bash_page(response, only_unknown)
      doc = Nokogiri::HTML(response.body)
      p1, p2 = nil
      quotes = []
      doc.css('table p').each do |paragraph|
        if p1.nil?
          p1 = paragraph
        else
          p2 = paragraph
          if quote = parse_bash_quote(p1, p2, only_unknown)
            quotes.push(quote)
          end
          p1, p2 = nil
        end
      end
      quotes
    end
    
    def parse_bash_quote(p1, p2, only_unknown)
      return nil unless (cite_id = (p1.css('a:first-child').attr('href').to_s.ltrim('?').to_i) rescue nil)
      return nil unless (cite = p2.to_str.trim) rescue nil
      return nil unless (cite.length > 0)
      if quote = quotes.where(:cite_id => cite_id).first
        return only_unknown ? nil : quote
      end
      Quote.create!({
        provider: self.name,
        cite_id: cite_id,
        cited_at: nil,
        cite: cite,
      })
    end
    
  end
end