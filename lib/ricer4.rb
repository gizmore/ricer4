require "ricer4/version"

load "activerecord-magic.rb"
load "active_record/magic/locale/arm-locales.rb"
load "active_record/magic/permission/arm-permissions.rb"

module Ricer4
  
  module Extend
    Filewalker.traverse_files(File.dirname(__FILE__)+"/ricer4/extend") do |file|
      load file
    end
  end

  module Include
    Filewalker.traverse_files(File.dirname(__FILE__)+"/ricer4/include") do |file|
      load file
    end
  end

  load "ricer4/validators/all.rb"
  load "ricer4/net/all.rb"
  load "ricer4/usage/all.rb"

  load "ricer4/bot.rb"
  
  load "ricer4/command/command_parser.rb"
  
  load "ricer4/model/all.rb"
  
  load "ricer4/loader/plugin_loader.rb"

  Filewalker.traverse_files(File.dirname(__FILE__)+"/ricer4/extend_plugins") do |file|
    load file
    Ricer4::Plugin.extend Ricer4::Extend.const_get(file.rsubstr_from('/').substr_to('.rb').camelize)
  end
  Ricer4::Plugin.extend ActiveRecord::Magic::Permissions::Extend


end
