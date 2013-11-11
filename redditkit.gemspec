# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redditkit/version'

Gem::Specification.new do |spec|
  spec.name          = "redditkit"
  spec.version       = RedditKit::Version
  spec.authors       = ["Sam Symons"]
  spec.email         = ["samsymons@me.com"]
  spec.description   = "A simple reddit API library, covering 100% of the reddit API."
  spec.summary       = "A simple reddit API library."
  spec.homepage      = "http://redditkit.com/"
  spec.license       = "MIT"

  spec.files = %w(LICENSE.md README.md Rakefile redditkit.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("spec/**/*")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', "~> 0.8"
  spec.add_development_dependency 'dotenv'
end
