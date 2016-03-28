module Ricer4::Plugins::Auth
  class Channelmod < Ricer4::Plugin
  
    trigger_is :modc
    connector_is :irc

    has_usage  '', scope: :channel , function: :execute_cshow
    has_usage  '<user>', scope: :channel , function: :execute_cshowu
    has_usage  '<user> <permission>', scope: :channel, function: :execute_cchange

    has_usage  '<channel>', scope: :user , function: :execute_show
    has_usage  '<channel> <user>', scope: :user, function: :execute_show_u
    has_usage  '<channel> <user> <permission>', scope: :user, function: :execute_change_u
    
    ###################################
    ### Channel funcs call wrappers ###
    ###################################
    def execute_cshow; execute_show_u(channel, user); end
    def execute_cshowu(user); execute_show_u(channel, user); end
    def execute_cchange(user, permission); execute_change_u(channel, user, permission); end

    ##############################
    ### Private query triggers ###
    ##############################
    def execute_show(channel)
       execute_show_u(channel, user)
    end

    def execute_show_u(channel, user)
      p = user.chanperm_for(channel)
      rply(:msg_show_chan,
        user: user.display_name,
        server: server.display_name,
        channel: channel.display_name,
        chanmode: p.chanmode.permission.display_symbols(p.channel_permission),
        bitstring: p.permission.display(p.channel_permission),
      )
    end

    def execute_change_u(channel, user, permission)
      rplyr :err_stub
      # TODO: Implement :P
    end

  end
end
