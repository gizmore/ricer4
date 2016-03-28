module Ricer4::Plugins::Vote
  class Votes < Ricer4::Plugin
    
    def upgrade_1
      require 'generators/acts_as_votable/migration/templates/active_record/migration.rb'
      ActsAsVotableMigration.new.up
    end
    
#    is_list_trigger :votes, :for => Ricer4::Plugins::Abbo::Abbonement
    
  end
end
