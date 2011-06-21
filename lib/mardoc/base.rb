module Mardoc
  class Base
    include Rack::Utils
    include Mardoc::Index
    
    def initialize(app=nil, options={})
      @app = app
      @docs_path   = File.join(Mardoc.proj_dir, Mardoc.docs_folder)
      @layout_path = File.join(Mardoc.proj_dir, Mardoc.layout_file)
      @doc_index ||= build_index
    end
    
    def call(env)
      @env = env
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      respond!
    end
  
    private
  
    def respond!
      @response['Content-Type'] = 'text/html'
      @response.write render(@request.path)
      @response.close
      @response.finish
    rescue Mardoc::PageNotFoundError
      render_404
    rescue Exception => e
      render_500(e)
    end
  
    def render(path)
      return render_sitemap if @request.path == '/sitemap'
      return render_search if @request.path == '/search'
      
      file_path   = File.join(@docs_path, path.sub(/\/$/, '/index').sub(/(\.md)?$/, '.md'))
      
      raise Mardoc::LayoutNotFoundError, "Layout not found at #{@layout_path}" unless File.exist? @layout_path
      raise Mardoc::PageNotFoundError, "Page not found at #{path}" unless File.exist? file_path 
      
      render_layout do
        render_doc(file_path)
      end
    end
    
    def render_sitemap
      sitemap_template_path = File.expand_path('views/sitemap.html.erb', File.dirname(__FILE__))
      
      render_layout do
        ERB.new(File.read(sitemap_template_path)).result(binding)
      end
    end
    
    def render_search
      search_template_path = File.expand_path('views/search.html.erb', File.dirname(__FILE__))
      search(@request.params['query'])
      
      render_layout do
        ERB.new(File.read(search_template_path)).result(binding)
      end
    end
    
    def render_layout(&block)
      ERB.new(File.read(@layout_path)).result(binding)
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
    
  end
end
