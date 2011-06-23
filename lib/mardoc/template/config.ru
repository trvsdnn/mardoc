require 'mardoc'
use Rack::Static, :urls => ['/css', '/js', '/images'], :root => 'assets'
run Mardoc::Base.new