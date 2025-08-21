# frozen_string_literal: true

source "https://rubygems.org"

gem "sinatra"
gem "webrick", "~> 1.9"

# For testing
group :development, :test do
  gem "rspec"
end

# For linting
group :development do
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
end
