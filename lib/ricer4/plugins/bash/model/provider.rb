module Ricer4::Plugins::Bash
  class Provider
    
    include Ricer4::Include::UsesInternet
    
    @@cache = {}
    def self.all; ActiveRecord::Magic::Param::BashProvider.bash_providers.collect { |provider| self.by_name(provider) }; end
    def self.by_name(name)
      name = name.to_s.camelize.gsub('/', '::')
      @@cache[name] ||= Ricer4::Plugins::Bash.const_get(name).new
    end

    
    def name; self.class.name.demodulize.underscore.to_sym; end
    def stub!(method_name); raise Ricer4::RuntimeException.new("Called stub method on #{self.class.name}: #{method_name}"); end
    
    def random
      more_random.first || Quote.order_by_rand.first
    end
    
    def latest
      more_latest(highest_id)
    end
    
    def highest_id
      quotes.order('cite_id DESC').first.id rescue 0
    end

    def get(cite_id)
      quotes.where(:cite_id => cite_id).first || get_number(cite_id)
    end
    
    def quotes
      Quote.send(self.name)
    end

    ################
    ### Override ###
    ################
    def display_name
      name
    end

    def more_random
      stub!('more_random')
    end
    
    def more_latest(high_id)
      stub!('more_latest')
    end
    
    def get_number(cite_id)
      stub!('number')
    end
    
    def send_search(term)
      stub!('search')
    end
    
  end
end