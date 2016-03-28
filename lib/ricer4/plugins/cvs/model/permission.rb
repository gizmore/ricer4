module Ricer4::Plugins::Cvs
  class Permission < ActiveRecord::Base
    
    self.table_name = :cvs_repo_perms
    
    belongs_to :repo, :class_name => "Ricer4::Plugins::Cvs::Repo"
    belongs_to :user, :class_name => 'Ricer4::User'
    
    def self.upgrade_1
      return if table_exists?
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
        t.integer :repo_id, :null => false
        t.integer :user_id, :null => false
      end
    end
    
  end
end
