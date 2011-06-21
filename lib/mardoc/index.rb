module Mardoc
  module Index

    def build_index      
      if File.exist? @docs_path
        index  = []
        md_ext = /\.md$/
        docs   = Dir["#{@docs_path}/**/*"].reject { |p| p.match(md_ext).nil? }
        
        docs.each do |doc_path|
          index << {
            :title   => doc_path.split('/').last.sub(md_ext, '').titlecase,
            :path    => doc_path.sub(@docs_path, '').sub(md_ext, '').sub(/\/index$/, '/'),
            :content => File.read(doc_path)
          }
        end
        
        index
      end
    end
    
    def search(query)
      @results     = []
      search_regex = Regexp.new("([^\\.\\?\\!\n]+(\\.|\\?|\\!)[^\\.\\?\\!]*#{query}[^\\.\\?\\!]*(\\.|\\?|\\!)[^\\.\\?\\!]+(\\.|\\?|\\!))", true)
      
      @doc_index.each do |doc|
        if doc[:content] =~ Regexp.new(query, true)
          result = doc.dup
          result[:summary] = RDiscount.new(doc[:content].match(search_regex)[1]).to_html
          @results << result
        end
      end
    end
  
   
  end
end
