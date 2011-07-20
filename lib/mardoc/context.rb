require 'ostruct'

module Mardoc
  class Context
        
    def initialize(vars={})
      vars.each { |k, v| instance_variable_set('@' + k.to_s, v) }
    end
    
    def nav(root=true)
      @doc_index.keep_if { |doc| current_folder(doc) } unless root
      @doc_index.map { |doc| build_nav_item(doc) }.reject { |doc| doc.path == '/' }
    end
    
    def get_binding
      binding
    end
    
    private
    
    def current_folder(doc)
      path = doc.path.gsub(File.join(Mardoc.proj_dir, Mardoc.docs_folder), '')
      @request.path.match(/^https?:\/\/[^\/]+(\/.+)\/.*$/)[1].include?(path)
    end
    
    def build_nav_item(item)
      OpenStruct.new({
        :title => item.title, 
        :path => item.path,
        :summary => summarize(item.content)
      })
    end
    
    def summarize(content)
      ''
    end
  
  end
end