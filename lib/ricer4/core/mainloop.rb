module Ricer4::Mainloop
  def mainloop

    bot.log.info("Rice up!")

    arm_publish('ricer/starting')

    startup
    
    bot.servers.each do |server|
      mainloop_server(server)
    end

    begin
      arm_publish('ricer/started')
      if starting_loop
        sleep 1.seconds
        arm_publish('ricer/ready')
        sleep 1.seconds
        cleanup_loop
      else
        bot.log.error("Ricer4 has no active servers!")
      end
    rescue Interrupt
      raise unless bot.running
      ctrl_c
    ensure
      bot.running = false
      arm_publish('ricer/stopped')
      bot.log.info("Ricer4 stopped!")
    end
  end
  
  def startup
    bot.running = true
    save_all_offline
    init_stub_message
  end

  def init_stub_message
    return if @stub_message
    @stub_message = m = Ricer4::Message.new
    m.raw = ""; m.prefix = "";
    m.type = "000"; m.args = []
    m.server = Ricer4::Server.new({hostname: 'stub'})
    m.sender = Ricer4::User.new({name: 'gizmore'})
    m.target = nil
    m
  end

  def save_all_offline
    bot.log.debug("Ricer4::Mainloop.save_all_offline")
    [Ricer4::User, Ricer4::Server, Ricer4::Channel, Ricer4::Chanperm].each do |klass|
      save_offline(klass)
    end
  end

  def save_offline(klass)
    bot.log.debug("Ricer4::Mainloop.save_offline(#{klass.name})")
    klass.update_all(:online => false)
    klass.arm_clear_cache
  end
  
  def mainloop_server(server)
    Ricer4::Thread.execute do
      while bot.running
        begin
          if server.enabled?
            server.connect!
          else
            sleep 10
          end
        rescue Ricer4::UnknownConnectorException => e
          bot.log.exception(e)
          break
        rescue => e
          bot.log.exception(e)
          sleep 10
        # rescue Exception => e
          # bot.log.exception(e)
          # raise e
        ensure
          sleep 1 if bot.running          
        end
      end # bot.running
    end
  end

  def starting_loop
    return false if (num_servers = bot.servers.enabled.count) == 0
    num_connect = 0
    sleep 3.seconds
    while num_connect != num_servers 
      num_connect = bot.servers.online.count
      break if bot.uptime > 2.minutes
      sleep 2.seconds
    end
    true
  end
  
  def cleanup_loop
    bot.log.info("Going into cleanup loop")
    while bot.running || some_servers_connected
      sleep(bot.running ? 1.5 : 0.5)
    end
  end
  
  def some_servers_connected
    bot.servers.each do |server|
      return true if server.connector.connected?
    end
    false
  end
  
  def ctrl_c
    bot.log.info("Mainloop.ctrl_c")
    bot.running = false
    bot.servers.online.each do |server|
      server.connector.send_quit("Caught SIGINT as ctrl+c was pressed and exiting cleanly.")
    end
  end
  
end
