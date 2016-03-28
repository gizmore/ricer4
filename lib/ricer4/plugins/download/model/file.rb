module Ricer4::Plugins::Download
  class File < ActiveRecord::Base
    
    self.table_name = "download_files"
    
    arm_install do |m|
      m.create_table table_name do |t|
        t.string :name, :null => false, :default => nil
        t.timestamps :null => false
      end
    end
    
  end
end