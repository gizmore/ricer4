module Ricer4::Plugins::Download
  class File < ActiveRecord::Base
    
    self.table_name = "download_files"
    
    def self.upgrade_1
      return if table_exists?
      m = ActiveRecord::Migration
      m.create_table table_name do |t|
        t.string :name, :null => false, :default => nil
        t.timestamps :null => false
      end
    end
    
  end
end