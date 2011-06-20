require File.dirname(__FILE__) + '/helper'

describe Mardoc::Base do
  before do
    Mardoc.docs_folder = 'test_app/docs'
    Mardoc.layout_file = 'test_app/layout.html.erb'
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Mardoc::Base))    
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
  
  it '404s if a page does not exist' do
    @browser.get '/not-real'
    @browser.last_response.ok?.must_equal false
    @browser.last_response.body.must_equal '404 Page not found at /not-real'
  end

end

