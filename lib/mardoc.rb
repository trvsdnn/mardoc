require 'rack'
require 'erb'
require 'rdiscount'
require 'mardoc/cli'
require 'mardoc/settings'
require 'mardoc/base'

module Mardoc
  class LayoutNotFoundError < StandardError; end
  class PageNotFoundError < StandardError; end
  class ConfigError < StandardError; end
    
  def self.configure
    settings = Mardoc::Settings.instance
    block_given? ? yield(settings) : settings
  end


  Mardoc::Settings.public_instance_methods(false).each do |name|
    (class << self; self; end).class_eval <<-EOT
      def #{name}(*args)
        configure.send("#{name}", *args)
      end
    EOT
  end
  
end
