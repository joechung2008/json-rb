# frozen_string_literal: true

source "https://rubygems.org"

gem "grape", "~> 2.4.0"
gem "puma", "~> 6.4"
gem "rack", "~> 3.2"
gem "rackup", "~> 2.1"
gem "roda", "~> 3.95"
gem "sinatra", "~> 4.1"
gem "webrick", "~> 1.9"

# For testing
group :development, :test do
  gem "rspec"
  gem "rubocop-rspec", require: false
end

# For linting and language server
group :development do
  gem "rubocop", require: false
  gem "ruby-lsp", require: false
end
