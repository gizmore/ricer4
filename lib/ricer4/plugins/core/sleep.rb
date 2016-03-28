module Ricer4::Plugins::Core
  class Sleep < Ricer4::Plugin

    trigger_is :sleep

    denial_of_service_protected max_threads: 3

    has_usage '<duration>'
    def execute(duration)
      threaded {
        sleep(duration)
      }
    end

  end
end
