module Ricer4::Plugins::Quote
  class Entity < ActiveRecord::Base
    
    include Ricer4::Include::Readable
    
    self.table_name = "quotes"
    
    acts_as_votable
    
    belongs_to :user,    :class_name => 'Ricer4::User'
    belongs_to :channel, :class_name => 'Ricer4::Channel'
 
    delegate :server, to: :user
    
    ###############
    ### Install ###
    ###############    
    arm_install do |m|
      m.create_table table_name do |t|
        t.integer   :user_id,    :null => false
        t.integer   :channel_id, :null => true
        t.text      :message,    :null => false
        t.timestamp :created_at
      end
    end

    ##################
    ### Searchable ###
    ##################    
    search_syntax do
      search_by :text do |scope, phrases|
        columns = [:message]
        scope.where_like(columns => phrases)
      end
      search_by :by do |scope, phrases|
        columns = ['users.name']
        scope.joins(:user).where_like(columns => phrases)
      end
      search_by :before do |scope, phrases|
        columns = ['quotes.updated_at']
        scope.where('quotes.updated at <= ?', phrases)
      end
      search_by :after do |scope, phrases|
        columns = ['quotes.updated_at']
        scope.where('quotes.updated_at >= ?', phrases)
      end
    end
    
    ################
    ### ListItem ###
    ################
    def display_date; I18n.l(self.created_at, :format => :short); end
    
    def display_ago; human_age(self.created_at); end
    
    def display_cite
      self.message.gsub("\n", ' ')
    end
    
    def display_list_item(number)
      I18n.t('ricer4.plugins.quote.display_list_item',
        id: self.id,
        by: self.user.display_name,
        ago: self.display_ago,
        likes: self.get_likes.count,
        message: self.display_cite,
      )
    end
    
    def display_show_item(number=1)
      I18n.t('ricer4.plugins.quote.display_show_item',
        id: self.id,
        message: self.display_cite,
        by: self.user.display_name,
        ago: self.display_ago,
        date: self.display_date,
        likes: self.get_likes.count,
      )
    end

  end
end
