Filewalker.traverse_files(File.dirname(__FILE__)) do |file|
  load file unless file.end_with?('/all.rb')
end

