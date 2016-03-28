module Ricer4::Plugins::Tcp
  class Tcp < Ricer4::Plugin
    
    has_files

    # Install SSL Certs unless they exist
    def upgrade_1
      unless plugin_file_exists?('ssl/private_key.pem')
        require "openssl"
        bot.log.info("TCP plugin generates RSA keys.")
        key = OpenSSL::PKey::RSA.new 4096
        open plugin_file_path('private_key.pem'), 'w' do |io| io.write key.to_pem end
        open plugin_file_path('public_key.pem'), 'w' do |io| io.write key.public_key.to_pem end
      end
    end
    
  end
end