module Ricer4::Plugins::Fun
  class HappyHour < Ricer4::Plugin
    
    trigger_is :happyhour
    permission_is :responsible

    has_usage
    def execute
      reply 'https://www.youtube.com/watch?feature=player_detailpage&v=E0Mi1ANe79o#t=527s'
    end
    
  end
end
