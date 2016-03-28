module Ricer4::Extend::HasFiles
  def has_files
    class_eval do |klass|
      require 'fileutils'
      FileUtils.mkdir_p Dir.pwd+"/files/#{klass.plugin_module.downcase}"
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
  end
end
