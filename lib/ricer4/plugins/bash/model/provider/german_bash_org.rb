module Ricer4::Plugins::Bash
  class GermanBashOrg < Provider
    
    def display_name; 'GBO'; end

    def more_random
      request_bash_page("http://german-bash.org/action/random", true)
    end

    def more_latest(high_id)
      if quotes = request_bash_page("http://german-bash.org/action/latest", true)
        quotes.select { |quote| quote.cite_id > high_id }
      end 
    end

    def get_number(cite_id)
      if quotes = request_bash_page("http://german-bash.org/#{cite_id}", false)
        quotes.first
      end
    end
    
    def search(term)
      request_bash_page("http://german-bash.org/?searchtext=#{URI::encode_www_form_component(term)}&search_in=inhalt&action=search_", false)
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
      quotes = []
      doc = Nokogiri::HTML(response.body)
      doc.css('div.quote').each do |div|
        if quote = parse_bash_quote(div, only_unknown)
          quotes.push(quote)
        end
      end
      quotes
    end
    
    def parse_bash_quote(div, only_unknown)
      return nil unless (cite_id = (div.css('a')[0].attr('href').to_s.ltrim('/').to_i) rescue nil)
      return nil unless (cite = div.css('div.zitat span.quote_zeile').collect{|line|line.to_str}.join.trim rescue nil)
      return nil unless (date = div.css('span.date').collect{|line|line.to_str}.join.trim rescue nil)
      return nil unless (date = DateTime.strptime(date, '%d.%m.%Y %H:%M') rescue nil)
      if quote = quotes.where(:cite_id => cite_id).first
        return only_unknown ? nil : quote
      end
      Quote.create!({
        provider: self.name,
        cite_id: cite_id,
        cited_at: date,
        cite: cite,
      })
    end
    
  end
end