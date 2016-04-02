module Ricer4::Plugins::Irc
  class JoinServer < Ricer4::Plugin
    
    trigger_is "join.server"

    permission_is :ircop
    
    has_setting name: :default_nick, type: :irc_nickname, scope: :bot, permission: :responsible, default: bot.config.nickname
    
    has_usage  '<server_url> <boolean|named:"peer_verify",default:true>', function: :execute_create
    has_usage  '<server_url>', function: :execute_create
    has_usage  '<server>',     function: :execute_rejoin

    ##############
    ### rejoin ###
    ##############
    def execute_rejoin(server)
      return erply :err_already_connected if server.connected?
      rply :msg_rejoining, :server => server.display_name
      byebug
    end
    
    ##############
    ### create ###
    ##############
    def execute_create(server_url, peer_verify=true)
      server = Ricer4::Server.new({
        conector: 'irc',
        name: server_url.domain,
        hostname: server_url.hostname,
        port: server_url.port,
        tls: server_url.scheme == 'ircs' ? (peer_verify ? 2 : 1) : 0,
        nickname: get_setting(:default_nick),
        username: bot.config.username,
        realname: bot.config.realname,
        userhost: bot.config.userhost,
      })
      execute_connect(server)
    end
      
    def execute_connect(server)
      server.instance_variable_set('@just_added_by', sender)
      service_threaded do
        hook = hook2 = nil
        hook = server.hook('irc/001') do |message|
          server.unhook(hook)
          server.unhook(hook2)
          server_authenticated(message)
        end
        hook2 = server.hook('irc/connect/failure') do |s,e|
          server.unhook(hook)
          server.unhook(hook2)
          connection_error(server, e)
        end
        server.connect!
      end
    end
    
    private
    
    def connection_error(server, e)
      bot.log.debug("JoinServer#connection_error")
      user = server.remove_instance_variable('@just_added_by')
      user.localize!.send_message(t(:err_connecting, server: server.display_name, reason: e.message), self, Ricer4::Reply::FAILURE)
    end
    
    def server_authenticated(message)
      server = message.server
      user = server.remove_instance_variable('@just_added_by')
      user.localize!.send_privmsg(t(:msg_connected,
        server: server.display_name,
        nickname: server.next_nickname,
        superword: generate_superword,
      ))
    end
    
    def generate_superword
      password = SecureRandom.base64(6).gsub('/', 'a')
      get_plugin('Auth/Super').save_setting(:password, :server, password)
      password
    end
    
  end
end
