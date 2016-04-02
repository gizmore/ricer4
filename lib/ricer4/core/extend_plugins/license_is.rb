# Ricer Independant Copyright Enclosed Document
module Ricer4::Extend::LicenseIs
  LICENSES ||= [:RICED, :MIT, :GPL, :PROPERITARY]
  def license_is(license)
    class_eval do |klass|

      license = license.to_s.upcase.to_sym
      unless LICENSES.include?(license)
        raise Ricer4::ConfigException.new("Unknown license for #{klass.name}: #{license}")
      end

      Ricer4::Plugin.register_class_variable(:@license)
      klass.set_class_variable(:@license, license)

      def plugin_license
        get_class_variable(:@license)
      end

    end
  end    
end
