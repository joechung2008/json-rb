Gem::Specification.new do |spec|
  spec.name          = "json_rb"
  spec.version       = "0.1.0"
  spec.authors       = ["Joe Chung"]
  spec.email         = ["joechung2008@example.com"]

  spec.summary       = "A custom JSON parser in Ruby"
  spec.description   = "A Ruby implementation of a JSON parser, ported from TypeScript"
  spec.homepage      = "https://github.com/joechung2008/json-rb"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage + ".git"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # Use Ruby glob for portability (works in Docker, CI, etc.)
  spec.files = Dir.glob("lib/**/*") + %w[json_rb.gemspec README.md LICENSE]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
