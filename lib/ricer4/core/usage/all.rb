load "ricer4/core/usage/parameter.rb"
load "ricer4/core/usage/usage.rb"
load "ricer4/core/usage/usages.rb"

Filewalker.traverse_files(File.dirname(__FILE__)+"/params") do |file|
  load file
end
