# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gitra/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'gitra'
  gem.version = "#{Gitra::VERSION}.dev"

  gem.summary     = "Git Repository Analyzer"
  gem.description = "Analyze branches and continuity in a git repository."
  gem.authors     = ['David Lantos']
  gem.email       = ['david.lantos@gmail.com']
  gem.homepage    = 'http://github.com/sldblog/gitra'

  gem.required_ruby_version = '>= 1.8.7'
  gem.add_dependency 'git'
  gem.add_dependency 'term-ansicolor'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'

  gem.executables   = ['gitra']
  gem.files         = Dir['Rakefile', '{bin,lib,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ["lib"]
end
