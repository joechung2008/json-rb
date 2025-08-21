# frozen_string_literal: true

source "https://rubygems.org"

gem "sinatra", "~> 4.1"
gem "webrick", "~> 1.9"

# For testing
group :development, :test do
  gem "rspec"
  gem "rubocop-rspec", require: false
end

# For linting
group :development do
  gem "rubocop", require: false
end

gem "roda", "~> 3.95"
