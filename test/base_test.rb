require File.dirname(__FILE__) + '/helper'

describe Mardoc::Base do
  include Rack::Test::Methods
  
  def app
    Mardoc::Base.new
  end
  
  before do
    Mardoc.proj_dir = File.join(Dir.pwd, 'test_app')
    Mardoc.docs_folder = 'docs'
    Mardoc.layout_file = 'layout.html.erb'
  end
  
  it 'resolves index pages' do
    get '/'
    last_response.ok?.must_equal true
    last_response.body.must_equal "<html><h1>index</h1>\n</html>"
  end

  it 'gets a page' do
    get '/one'
    last_response.ok?.must_equal true
    last_response.body.must_equal "<html><h1>one</h1>\n</html>"
  end
  
  it 'gets a nested page' do
    get '/deep/two'
    last_response.ok?.must_equal true
    last_response.body.must_equal "<html><h1>deep/two</h1>\n\n<p>Guess what? Here lives two, the best thing in the world. This is for search, and other stuff.</p>\n</html>"
  end
  
  it 'generates a sitemap' do
    get '/sitemap'
    last_response.ok?.must_equal true
    last_response.body.must_equal "<html><ul>\n\n  <li><a href='/deep/two'>Two</a></li>\n\n  <li><a href='/'>Index</a></li>\n\n  <li><a href='/one'>One</a></li>\n\n</ul></html>"
  end
  
  it 'searches the docs for a given query' do
    get '/search?query=two'
    last_response.ok?.must_equal true
    last_response.body.must_equal "<html><div id='results'>\n  <ul>\n  \n    <li>\n      <a href='/deep/two'>Two</a>\n      <p>Guess what? Here lives two, the best thing in the world. This is for search, and other stuff.</p>\n\n    </li>\n  \n  </ul>\n</div></html>"
  end
  
  it '404s if a page does not exist' do
    get '/not-real'
    last_response.ok?.must_equal false
    last_response.body.must_match Regexp.new('Page Not Found at \\/not\\-real')
  end

end

