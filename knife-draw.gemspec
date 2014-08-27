# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife_draw/version'

Gem::Specification.new do |spec|
  spec.name          = "knife-draw"
  spec.version       = KnifeDraw::VERSION
  spec.authors       = ["Joshua Flanagan"]
  spec.email         = ["joshuaflanagan@gmail.com"]
  spec.summary       = %q{Draws pictures using your Chef data}
  spec.description   = %q{Generates GraphViz diagrams based on your Chef environment}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "chef"
  spec.add_dependency "graphviz"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
