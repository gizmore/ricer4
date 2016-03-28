load "ricer4/usage/parameter.rb"
load "ricer4/usage/usage.rb"
load "ricer4/usage/usages.rb"

Filewalker.traverse_files(File.dirname(__FILE__)+"/params") do |file|
  load file
end
