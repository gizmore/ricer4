module Ricer4::Extend::VersionIs
  def version_is(version)
    class_eval do |klass|
      unless version.is_a?(Integer) && version.between?(1, 100)
        raise StandardError.new("Version in #{klass.name} is not an integer between 1 and 100: #{version}")
      end
      klass.register_class_variable(:@version)
      klass.set_class_variable(:@version, version)
      def plugin_version
        self.class.get_class_variable(:@version, 1)
      end
    end
  end    
end
