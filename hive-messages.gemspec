# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "hive-messages"
  spec.version       = '1.0.1'
  spec.authors       = ["David Buckhurst", "Paul Carey"]
  spec.email         = ["david.buckhurst@bbc.co.uk"]
  spec.summary       = %q{Hive communication library.}
  spec.description   = %q{Hive Messages, communications between hive components.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus", "~> 1.0"
  spec.add_dependency "roar", "~> 1.0"
  spec.add_dependency "activemodel", ">= 4.0", "< 4.3"
  spec.add_dependency "activesupport", ">= 4.0", "< 4.3"
  spec.add_dependency "multipart-post", "~> 2.0"
  spec.add_dependency "mimemagic", "~> 0.3"
  spec.add_dependency "multi_json", "~> 1.11"

  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "shoulda-matchers", "~> 2.8"
  spec.add_development_dependency "webmock", "~> 1.21"
end
