module Mardoc
  class Base
    include Rack::Utils
    
    class << self
      def call(env)
        @doc_index ||= build_index
        dup.call!(env)
      end

      def call!(env)
        @env = env
        @request = Rack::Request.new(env)
        @response = Rack::Response.new
        respond!
      end
    
      private
    
      def respond!
        @response['Content-Type'] = Rack::Mime.mime_type(File.extname(@request.path), 'text/html')
        @response.write render(@request.path)
        @response.close
        @response.finish
      rescue Mardoc::PageNotFoundError
        render_404
      rescue Exception => e
        render_500(e)
      end
    
      def render(path)
        docs_path   = File.join(Mardoc.proj_dir, Mardoc.docs_folder)
        layout_path = File.join(Mardoc.proj_dir, Mardoc.layout_file)
        file_path   = File.join(docs_path, path.sub(/(\.md)?$/, '.md'))
        
        raise Mardoc::LayoutNotFoundError, "Layout not found at #{layout_path}" unless File.exist? layout_path
        raise Mardoc::PageNotFoundError, "Page not found at #{path}" unless File.exist? file_path 
        
        render_layout(layout_path) do
          render_doc(file_path)
        end
      end
      
      def render_layout(layout_path, &block)
        ERB.new(File.read(layout_path)).result(binding)
      end
    
      def render_doc(file_path)
        markdown = RDiscount.new(File.read(file_path))
        markdown.to_html
      end
    
      def render_404
        @response.status = 404
        @response.write "404 Page not found at #{@request.path}"
        @response.close
        @response.finish
      end
    
      def render_500(exception)
        @response.status = 500
        @response.write "<p>#{exception.message.to_s}<p/><p>#{exception.backtrace.join('<br />')}</p>"
        @response.close
        @response.finish
      end
      
      def build_index
        docs_path = File.join(Mardoc.proj_dir, Mardoc.docs_folder)
        if File.exist? docs_path
          md_ext = /\.md$/
          Dir["#{docs_path}/**/*"].reject { |p| p.match(md_ext).nil? }.map { |p| p.sub(Mardoc.proj_dir, '').sub(md_ext, '') }
        end
      end
      
    
    end
  end
end
