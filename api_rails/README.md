# Rails API

A minimal Rails API application built with Rails 8.0.2.

## Configuration

The application is configured as an API-only Rails app with the following key settings:

- `config.api_only = true` - No view rendering
- ActiveRecord completely removed for minimal footprint
- Action Mailer disabled
- Action Cable disabled
- Action View disabled
- Active Job disabled for synchronous operations only
- Internationalization (i18n) disabled for simplicity

## Ruby Version

- Ruby 3.3.9
- Rails 8.0.2

## System Dependencies

- Bundler

## Testing

This Rails API uses Rails' built-in testing framework (Minitest).

### Run All Tests

```bash
# Run all tests
rails test

# Run tests with verbose output
rails test -v

# Run tests in quiet mode
rails test -q
```

### Run Specific Tests

```bash
# Run a specific test file
rails test test/controllers/api/v1/parse_controller_test.rb

# Run a specific test by line number
rails test test/controllers/api/v1/parse_controller_test.rb:10

# Run tests in a line range
rails test test/controllers/api/v1/parse_controller_test.rb:10-20

# Run all controller tests
rails test test/controllers
```

### Test Output

- 9 tests covering the parse API endpoint
- Tests validate JSON parsing functionality
- Tests check error handling for invalid JSON
- All tests should pass with 0 failures and 0 errors

## Development Tools

### Code Quality & Security

#### RuboCop (Code Style)

This project uses `.rubocop-rails.yml` instead of the standard `.rubocop.yml` filename to avoid configuration inheritance from the parent project.

```bash
# Check code style
rubocop --config .rubocop-rails.yml

# Auto-fix style issues
rubocop --config .rubocop-rails.yml --autocorrect

# Check specific files
rubocop --config .rubocop-rails.yml app/controllers/
```

**Why `.rubocop-rails.yml`?**
RuboCop automatically discovers and inherits from parent `.rubocop.yml` files, which causes conflicts with the parent project's exclusion rules. Using a custom filename with the `--config` flag provides complete configuration isolation.

#### Brakeman (Security Scanner)

Brakeman is a static analysis security scanner for Rails applications.

```bash
# Run security scan
brakeman

# Generate HTML report
brakeman -o report.html

# Generate JSON report
brakeman -f json

# Quiet mode (less output)
brakeman -q
```

Brakeman checks for:

- SQL injection vulnerabilities
- Cross-site scripting (XSS)
- Cross-site request forgery (CSRF)
- Mass assignment issues
- Command injection
- And many other Rails security problems

### Debugging

The application includes the `debug` gem for debugging:

```bash
# Add `debugger` to your code to start a debugging session
debugger
```

## How to Run the Application

```bash
# Install dependencies
bundle install

# Start the server
rails server
```

The server will start on `http://localhost:8000` by default.

## Using the Custom JSON Parser Gem

This Rails API can use the custom JSON parser from the parent project as a local gem.

### Development Setup (Path Gem)

For development, the gem is already configured as a path gem in `Gemfile`:

```ruby
gem "json_rb", path: "../"
```

Run `bundle install` to use the local parser directly.
