
module Ricer4::Plugins::Fun
  class Wtf < Ricer4::Plugin

    trigger_is :wtf
    
    has_usage  '<message>', function: :execute_wtf

    def execute_wtf(message)
      # require 'nokogiri'
      # require 'open-uri'
      threaded do
        urban_dictionary_url = "http://www.urbandictionary.com/define.php?term=#{URI::encode_www_form_component(message)}"
        doc = Nokogiri::HTML(open(urban_dictionary_url), nil, 'UTF-8')
        if doc.at_css('.meaning')
          reply doc.at_css('.meaning').content.strip
          example = doc.at_css('.example').content.strip rescue nil
          unless example.nil? || example.empty?
            rply :msg_example, example:example
          end 
        else
          rply :err_not_found
        end
      end
    end
    
  end
end
