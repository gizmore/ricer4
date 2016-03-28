module Ricer4::Plugins::Vote
  class Votes < Ricer4::Plugin
    
    arm_install do |m|
      require 'generators/acts_as_votable/migration/templates/active_record/migration.rb'
      ActsAsVotableMigration.new.up
    end
    
    def plugin_init
      
    end
    
  end
end
