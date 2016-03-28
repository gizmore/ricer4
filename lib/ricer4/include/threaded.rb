module Ricer4::Include::Threaded
  
  def threaded(&block)
    threaded_org(&block)
  end
  
  def threaded_org(&block)
    current_command.threading = true
    guid = Ricer3::Thread.fork_counter_inc
    Ricer3::Thread.execute do
      begin
        bot.log.debug "[#{guid}] Started thread at #{display_proc(proc)}"
        yield
      rescue Interrupt, SignalException
        raise
      rescue Exception => e
        reply_exception(e)
      ensure
        bot.log.debug "[#{guid}] Stopped thread at #{display_proc(proc)}"
        current_command.late_processed
      end
    end
  end
  
  def worker_threaded(&block)
    guid = Ricer3::Thread.fork_counter_inc
    Ricer3::Thread.execute do
      begin
        bot.log.debug "[#{guid}] Started worker thread at #{display_proc(proc)}"
        yield
      rescue Interrupt, SignalException
        raise
      rescue Exception => e
        bot.log.exception(e)
      ensure
        bot.log.debug "[#{guid}] Stopped worker thread at #{display_proc(proc)}"
      end
    end
  end

  def service_threaded(&block)
    guid = Ricer3::Thread.fork_counter_inc
    Ricer3::Thread.execute do
      begin
        bot.log.debug "[#{guid}] Started service thread at #{display_proc(proc)}"
        yield
      rescue Interrupt, SignalException
        raise
      rescue Exception => e
        send_exception(e)
      ensure
        bot.log.debug "[#{guid}] Stopped service thread at #{display_proc(proc)}"
      end
    end
  end
  
  private

  def display_proc(proc)
    (file, line = *proc.source_location) or raise RuntimeError.new("No sourcecode line for proc.")
    "#{file} #{line}"
  end
  
end