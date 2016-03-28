module Ricer4::Plugins::Irc
  class Motd < ActiveRecord::Base
    
    strip_attributes
    
    self.table_name = "server_motds"
    
    def self.upgrade_1
      return if table_exists?
      m = ActiveRecord::Migration
      m.create_table table_name do |t|
        t.integer    :server_id,    :default => nil, :null => false, :unsigned => true, :unique => true
        t.text       :text,         :default => nil, :null => true
        t.timestamp  :updated_at,   :default => nil, :null => false
      end
      m.add_foreign_key table_name, :servers, :on_delete => :cascade
    end
    
    def server
      Ricer4::Server.by_id(server_id)
    end

    def self.static_for_server(server)
      @statics ||= {}
      @statics[server.id] ||= self.for_server(server)
    end
    
    def self.for_server(server)
      find_or_create_by!(:server_id => server.id)
    end

    
  end
end