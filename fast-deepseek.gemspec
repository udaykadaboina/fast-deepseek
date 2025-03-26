# frozen_string_literal: true

require_relative "lib/fast_deepseek/version"

Gem::Specification.new do |spec|
  spec.name = "fast-deepseek"
  spec.version = FastDeepseek::VERSION
  spec.authors = ["Uday Kadaboina"]
  spec.email = ["uday88k@gmail.com"]

  spec.summary       = "A fast wrapper for DeepSeek API"
  spec.description   = "Provides an easy-to-use interface for interacting with DeepSeek API."
  spec.homepage      = "https://github.com/udaykadaboina/fast-deepseek"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/udaykadaboina/fast-deepseek",
    "changelog_uri" => "https://github.com/udaykadaboina/fast-deepseek/releases/tag/v#{FastDeepseek::VERSION}",
    "rubygems_mfa_required" => "true"
  }

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.files = Dir["lib/**/*.rb"] + Dir["bin/*"]

  spec.add_dependency "faraday", "~> 2.0"
end
