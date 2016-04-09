module Ricer4
  class Thread < ::Thread
    
    @@limits = {} # Number of jobs per user
    #@@mutex = Mutex.new # Mutex for guid counter

    @@peak = 1; def self.peak; @@peak; end # Performance peak counter
    def self.count; list.length; end # Performance currently running
    
    @@fork_counter = 2 # Global execution calls counter / fork_count
    def self.fork_counter; @@fork_counter; end # 
    def self.fork_counter_inc; @@fork_counter += 1; end # 
      
    def initialize
      super
      now = Thread.list.length
      @@peak = now if now > @@peak
    end
    
    ####################################
    ### Debug and Exception handling ###
    ####################################
    def self.execute(&block)
      old_message = current_message
      old_command = current_command
      new do
        Thread.current[:ricer_message] = old_message
        Thread.current[:ricer_command] = old_command 
        yield
      end
    end

  end
end
