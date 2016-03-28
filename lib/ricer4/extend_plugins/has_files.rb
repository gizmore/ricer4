module Ricer4::Extend::HasFiles
  
  module Methods
    def plugin_file_dir
      Dir.pwd+"/files/#{plugin_module.downcase}"
    end
    def plugin_file_path(path)
      plugin_file_dir+"/"+path
    end
    def plugin_file_exists?(path)
      File.file?(plugin_file_path(path))
    end
  end
  
  def has_files
    class_eval do |klass|
      require 'fileutils'
      FileUtils.mkdir_p Dir.pwd+"/files/#{klass.plugin_module.downcase}"
      klass.extend Ricer4::Extend::HasFiles::Methods
      klass.send :include, Ricer4::Extend::HasFiles::Methods
    end
  end

end
