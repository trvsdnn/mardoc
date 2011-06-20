require 'singleton'

module Mardoc
  class Settings
    include Singleton
    
    attr_accessor :environment
    attr_accessor :proj_dir
    attr_accessor :docs_folder
    attr_accessor :layout_file
    
    def initialize
      reset_settings
    end
    
    def reset_settings
      @environment = :production
      @proj_dir    = Dir.pwd
      @docs_folder = 'docs'
      @layout_file = 'layout.html.erb'
    end
    
    def production?
      @environment == :production
    end
    
    def testing?
      @environment == :testing
    end
    
  end
end