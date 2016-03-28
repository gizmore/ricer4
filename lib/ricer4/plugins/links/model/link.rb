module Ricer4::Plugins::Links
  module Model
    class Link < ActiveRecord::Base
      
      acts_as_votable
      
      belongs_to :user, :class_name => 'Ricer4::User'
      belongs_to :channel, :class_name => 'Ricer4::Channel'
      
      ###############
      ### Install ###
      ###############
      arm_install do |m|
        m.create_table table_name do |t|
          t.string    :url,          :null => false, :unique => true
          t.string    :title,        :null => true
          t.integer   :user_id,      :null => false
          t.integer   :channel_id,   :null => true
          t.string    :hash,         :null => false, :length => Ricer4::Hash::LENGTH, :charset => :ascii, :collate => :ascii_bin, :unique => true
          t.string    :mime_type,    :null => false, :length => 128,                  :charset => :ascii, :collate => :ascii_bin
          t.integer   :added,        :null => false, :default => 0
          t.timestamps :null => false
        end
      end
      
      arm_install do |m|
        self.mkdir
      end
  
      #################
      ### Directory ###
      #################
      def self.root_dir; "#{Dir.pwd}/files/images"; end
  
      def self.cleardir; rmdir && mkdir; end
  
      def self.mkdir
        dir = self.root_dir
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
      end
      
      def self.rmdir
        dir = self.root_dir
        FileUtils.remove_dir(dir) if File.directory?(dir)
      end
      
      def today
        self.created_at.strftime("%Y%m%d")
      end
      
      def today_dir
        "#{self.class.root_dir}/#{today}"
      end
         
      def mkdir_today
        dir = today_dir
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
      end
      
      def dir_today
        mkdir_today
        today_dir
      end
      
      ##################
      ### Save image ###
      ##################
      def image_filename
        "#{self.id}-#{self.clean_title}"
      end
      
      def clean_title
        self.title.gsub(/[^-a-z_0-9.,]/, '')
      end
      
      def image_path
        "#{self.dir_today}/#{image_filename}"
      end
  
      def save_image(image_data)
        mkdir_today
        File.open(image_path, "wb") do |f|
          f.write(image_data)
        end
      end
      
      ###############
      ### Display ###
      ###############
      def display_list_item(number)
        I18n.t('ricer3.plugins.links.display_list_item', {number: number, id: self.id, url: url, title: title})
      end
      def display_show_item(number)
        I18n.t('ricer3.plugins.links.display_show_item', {number: number, id: self.id, url: url, title: title})
      end
      
    end
  end
end
