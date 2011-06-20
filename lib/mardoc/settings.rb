require 'singleton'

module Mardoc
  class Settings
    include Singleton
    
    attr_accessor :environment
    attr_accessor :docs_folder
    attr_accessor :layout_file
    
    def initialize
      reset_settings
    end
    
    def reset_settings
      @environment = :production
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