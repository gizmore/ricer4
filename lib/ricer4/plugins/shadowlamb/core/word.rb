module Ricer4::Plugins::Shadowlamb::Core
  class Word < ActiveRecord::Base
    
    include Include::Base
    include Include::Translates

    self.table_name = 'sl5_words'
    arm_cache; def should_cache?; true; end

    ###############
    ### Install ###
    ###############    
    def self.upgrade_1
      unless ActiveRecord::Base.connection.table_exists?(table_name)
        m = ActiveRecord::Migration.new
        m.create_table table_name do |t|
          t.string  :name, :limit => 32, :null => false, :collation => :ascii_bin, :charset => :ascii
        end
      end
    end
    def self.upgrade_2
      m = ActiveRecord::Migration.new
      m.add_index table_name, :name, :unique => true, :name => :unique_word_names rescue nil
    end
    
    def self.hello
      @_hello ||= find_or_create_by(name: 'hello')
    end
    
    
    ###
    def display_name
      t!("words.#{self.name.downcase}") rescue self.name.downcase
    end
    
  end
end
