require "ricer4/version"

load "activerecord-magic.rb"
load "active_record/magic/locale/arm-locales.rb"
#load "active_record/magic/permission/arm-permissions.rb"

module Ricer4
  
  module Extend
    Filewalker.traverse_files(File.dirname(__FILE__)+"/ricer4/core/extend") do |file|
      load file
    end
  end

  module Include
    Filewalker.traverse_files(File.dirname(__FILE__)+"/ricer4/core/include") do |file|
      load file
    end
  end

  load "ricer4/core/validators/all.rb"
  load "ricer4/core/net/all.rb"
  load "ricer4/core/usage/all.rb"

  load "ricer4/core/bot.rb"
  
  load "ricer4/core/command/command_parser.rb"
  
  load "ricer4/core/model/all.rb"
  
  load "ricer4/core/loader/plugin_loader.rb"

  Filewalker.traverse_files(File.dirname(__FILE__)+"/ricer4/core/extend_plugins", '*.rb') do |file|
    load file
    Ricer4::Plugin.extend Ricer4::Extend.const_get(file.rsubstr_from('/').substr_to('.rb').camelize)
  end

end
