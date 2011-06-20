# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require "mardoc/version"

Gem::Specification.new do |s|
  s.name        = "mardoc"
  s.version     = Mardoc::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['blahed']
  s.email       = ['tdunn13@gmail.com']
  s.homepage    = ''
  s.summary     = 'A Markdown powered documentation server with git integration'
  s.description = ''

  s.rubyforge_project = 'mardoc'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
