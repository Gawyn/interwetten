# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interwetten/version'

Gem::Specification.new do |spec|
  spec.name          = "interwetten"
  spec.version       = Interwetten::VERSION
  spec.authors       = ["Cristian Planas"]
  spec.email         = ["me@cristianplanas.com"]
  spec.description   = %q{A Ruby wrapper for the Interwetten API}
  spec.summary       = %q{A Ruby wrapper for the Interwetten API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'active_support'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'webmock'
end
