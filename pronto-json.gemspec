# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pronto/json/version'

Gem::Specification.new do |spec|
  spec.name          = 'pronto-json'
  spec.version       = Pronto::Json::VERSION
  spec.authors       = ['Tomas Brazys']
  spec.email         = ['tomas.brazys@gmail.com']

  spec.summary       = 'Pronto runner for JSON parsing'
  spec.homepage      = 'https://github.com/deees/pronto-json'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'pronto', '~> 0.6.0'
  spec.add_dependency 'oj', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
