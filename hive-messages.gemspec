# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "hive-messages"
  spec.version       = '0.4.0'
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

  spec.add_dependency "virtus"
  spec.add_dependency "roar"
  spec.add_dependency "activemodel"
  spec.add_dependency "activesupport"
  spec.add_dependency "multipart-post"
  spec.add_dependency "mimemagic"

  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "shoulda-matchers"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"
end
