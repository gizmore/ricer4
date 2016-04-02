module Ricer4::Plugins::Board
  module Model
    class Announcement
      
      include Ricer4::Include::NoHighlight
  
      attr_reader :thread, :date, :board, :url, :user, :title
      
      def initialize(parts)
        @thread, @date, @board, @url, @user, @title = *parts
      end
      
      def display_entry
        tt("ricer4.plugins.board.entry", {
          user: no_highlight(@user),
          date: l(@date),
          title: @title,
          url: @url,
        })
      end

    end
  end
end
