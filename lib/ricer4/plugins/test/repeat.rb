module Ricer4::Plugins::Test
  class Repeat < Ricer4::Plugin
    
    trigger_is :repeat
    permission_is :responsible

    has_usage '<integer|min:0,max:30> <message>'
    def execute(repeat, command_line)
      repeat.times do
        exec_line(command_line)
      end
    end

  end
end
