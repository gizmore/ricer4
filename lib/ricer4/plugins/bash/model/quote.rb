module Ricer4::Plugins::Bash
  class Quote < ActiveRecord::Base

    include Ricer4::Include::Readable
    include Ricer4::Include::HasEnum
    
    acts_as_votable

    has_enum provider: ActiveRecord::Magic::Param::BashProvider.bash_providers

    self.table_name = "bash_quotes"
    
    def self.unseen; where(:shown => 0); end
    
    ###############
    ### Install ###
    ###############
    arm_install do |m|
      m.create_table table_name do |t|
        t.integer   :cite_id,    :null => false, :unsigned => true 
        t.integer   :provider,   :null => false, :unsigned => true, :length => 2
        t.text      :cite,       :null => false
        t.integer   :shown,      :null => false, :unsigned => true, :default => 0
        t.timestamp :cited_at,   :null => true
        t.timestamp :created_at, :null => false
        # t.integer   :cached_votes_total,      :default => 0
        # t.integer   :cached_votes_score,      :default => 0
        # t.integer   :cached_votes_up,         :default => 0
        # t.integer   :cached_votes_down,       :default => 0
        t.integer   :cached_weighted_score,   :default => 0
        t.integer   :cached_weighted_total,   :default => 0
        # t.float     :cached_weighted_average, :default => 0.0
      end
      m.add_index table_name, [:cite_id, :provider], :name => :unique_cites, :unique => true
      # m.add_index table_name, :cached_votes_total
      # m.add_index table_name, :cached_votes_score
      # m.add_index table_name, :cached_votes_up
      # m.add_index table_name, :cached_votes_down
      m.add_index table_name, :cached_weighted_score
      m.add_index table_name, :cached_weighted_total
      # m.add_index table_name, :cached_weighted_average
    end
    
    #############
    ### Votes ###
    #############
    def vote_quality
      quality = (self.cached_weighted_score / self.cached_weighted_total) rescue 0.0
      quality.round(2)
    end
    
    ################
    ### Provider ###
    ################
    def get_provider
      Provider.by_name(self.provider)
    end
    
    ############
    ### Show ###
    ############
    def display_provider; get_provider.display_name; end
    def display_cited_at; I18n.l(self.cited_at||self.created_at); end
    
    def display_item(key, position)
      I18n.t(key,
        id: self.id,
        position: position,
        cite_id: self.cite_id,
        provider: display_provider,
        cite_text: self.cite,
        votes: self.votes_for.count,
        likes: self.get_likes.count,
        quality: self.vote_quality,
        shown: self.shown,
      )
    end
    def display_show_item(position)
      self.shown += 1
      self.save!
      display_item('ricer4.plugins.bash.quote.show_item', position)
    end
    def display_list_item(position)
      display_item('ricer4.plugins.bash.quote.list_item', position)
    end
      
  end
end