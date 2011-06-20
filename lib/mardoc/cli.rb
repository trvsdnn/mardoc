require 'fileutils'

module Mardoc
  class CLI
    
    class << self
    
      BANNER = <<-USAGE
      Usage:
        mardoc init PROJECT_PATH

      Description:
        The `mardoc init' command generates a mardoc project template.

        Once you have a project template, you can start dropping markup documenation
        files in the `docs' directory. After you have some documenation, just run rackup
        in the mardoc project directory to start the server and view the documentation.
      
        Edit the layout and the files in the assets folder to style or add images to the documentation.

      Example:
        mardoc init ~/Dev/documentation
        cd ~/Dev/documentation
      
        # add some documentation to ~/Dev/documentation/docs
        echo "# Hello World" >> ~/Dev/documentation/docs/hello.md 

        # fire up a server
        rackup
      
        # view the docs
        curl http://0.0.0.0:9292/hello
      
      USAGE
    
      def set_options
        @opts = OptionParser.new do |opts|
          opts.banner = BANNER.gsub(/^\s{4}/, '')

          opts.separator ''

          opts.on('-v', '--version', 'Show the mardoc version and exit') do
            puts "Mardoc v#{Mardoc::VERSION}"
            exit
          end

          opts.on( '-h', '--help', 'Display this help' ) do
            puts opts
            exit
          end
        end

        @opts.parse!
      end
    
      def print_usage_and_exit!
        puts @opts
        exit
      end
      
      def create_project_dir(new_project_path)
        if File.exist? new_project_path
          $stderr.puts " \033[31muh oh, '#{new_project_path}' already exists...\033[0m"
        else
          Dir.mkdir(new_project_path)
        end
      end
    
      def copy_template(new_project_path)
        template_files = Dir.glob(File.expand_path( 'template/*', File.dirname(__FILE__) ))
        FileUtils.cp_r(template_files, new_project_path)
      end
    
      def run!
        case ARGV.first
        when 'init'
          print_usage_and_exit! unless ARGV[1]
          new_project_path = ARGV[1]
          
          create_project_dir(new_project_path)
          copy_template(new_project_path)
          
          $stdout.puts " \033[32m'#{new_project_path}' is ready to go, start documenting!\033[0m"
        else
          $stderr.puts "mardoc can't do that... `mardoc --help' for usage"
          exit
        end
      end
      
    end 
  end
end