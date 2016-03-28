module Ricer4
  class Parameter < ActiveRecord::Magic::Parameter

    ###############
    ### Factory ###
    ###############
    # Create a Parameter from a usage pattern snippet like # [<..text..>] or # [<integer|min:5,max:8,test:"abc",arr:[foo],prices:{foo:bar}>]
    def self.from_pattern(pattern)
      optional = pattern.starts_with?('['); pattern.trim!('[]') # parse [optional]
      pattern.trim!('<>') # parse '<>'
      eater = pattern.starts_with?('.'); pattern.trim!('.') # parse ..eater..
      options = options_from_optionstr(pattern.substr_from('|') || '') # parse options:4,foo:5
      classname = (pattern.substr_to('|') || pattern).camelize # parse classname integer:
      options.merge!({
        type: classname,
        null: optional,
        eater: eater
      })
      self.from_setting_options(options)
    end
    
    # Parse optionstring part of a pattern into hash.
    # @param optionstr String @example: min=5,default="foo,bar",blub=blab,styles=[foo,bar]
    def self.options_from_optionstr(optionstr='')
      eval "{#{optionstr}}"
    end

  end
end
