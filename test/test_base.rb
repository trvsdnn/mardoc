require File.dirname(__FILE__) + '/helper'

describe Mardoc::Base do
  before do
    Mardoc.proj_dir = File.join(Dir.pwd, 'test_app')
    Mardoc.docs_folder = 'docs'
    Mardoc.layout_file = 'layout.html.erb'
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Mardoc::Base))    
  end
  
  it 'resolves index pages' do
    @browser.get '/'
    @browser.last_response.ok?.must_equal true
    @browser.last_response.body.must_equal "<html><h1>index</h1>\n</html>"
  end

  it 'gets a page' do
    @browser.get '/one'
    @browser.last_response.ok?.must_equal true
    @browser.last_response.body.must_equal "<html><h1>one</h1>\n</html>"
  end
  
  it 'gets a nested page' do
    @browser.get '/deep/two'
    @browser.last_response.ok?.must_equal true
    @browser.last_response.body.must_equal "<html><h1>deep/two</h1>\n</html>"
  end
  
  it 'generates a sitemap' do
    @browser.get '/sitemap'
    @browser.last_response.ok?.must_equal true
    @browser.last_response.body.must_equal "<html><ul>\n\n  <li><a href='/deep/two'>/deep/two</a></li>\n\n  <li><a href='/'>/</a></li>\n\n  <li><a href='/one'>/one</a></li>\n\n</ul></html>"
  end
  
  it '404s if a page does not exist' do
    @browser.get '/not-real'
    @browser.last_response.ok?.must_equal false
    @browser.last_response.body.must_equal '404 Page not found at /not-real'
  end

end

