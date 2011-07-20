module Mardoc
  module Index
    
    class Item
      attr_reader :title, :path, :content
      
      def initialize(doc_path)
        @docs_path = File.join(Mardoc.proj_dir, Mardoc.docs_folder)
        @title = get_title(doc_path)
        @path  = get_path(doc_path)
        @content = File.read(doc_path)
      end
      
      private
      
      def get_title(doc_path)
        doc_path.split('/').last.sub(Mardoc::MD_EXT, '').titlecase
      end
      
      def get_path(doc_path)
        doc_path.sub(@docs_path, '').sub(Mardoc::MD_EXT, '').sub(/\/index$/, '/')
      end
    end

    def self.build
      docs_path = File.join(Mardoc.proj_dir, Mardoc.docs_folder)
      
      if File.exist? docs_path
        docs = Dir["#{docs_path}/**/*"].reject { |p| p.match(Mardoc::MD_EXT).nil? }
        docs.map { |doc_path| Mardoc::Index::Item.new(doc_path) }
      end
    end
    
    # def self.search(query)
    #   @results     = []
    #   search_regex = Regexp.new("([^\\.\\?\\!\n]+(\\.|\\?|\\!)[^\\.\\?\\!]*#{query}[^\\.\\?\\!]*(\\.|\\?|\\!)[^\\.\\?\\!]+(\\.|\\?|\\!))", true)
    #   
    #   @doc_index.each do |doc|
    #     if doc[:content] =~ Regexp.new(query, true)
    #       result = doc.dup
    #       result[:summary] = RDiscount.new(doc[:content].match(search_regex)[1]).to_html
    #       @results << result
    #     end
    #   end
    # end
  
   
  end
end
