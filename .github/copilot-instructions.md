// ...existing code...

## AI Coding Agent Instructions for json-rb

### Project Overview

- This is a Ruby implementation of a JSON parser, ported from TypeScript. It includes a CLI, Grape-based API, Rails-based API, Roda-based API, Sinatra-based API, and a modular parser in `lib/`.
- The parser is custom and does not use Ruby's built-in `JSON` for parsing; see `lib/json.rb` and related files for the core logic.

### Architecture & Major Components

- **lib/**: Core parsing logic. Key modules: `json.rb`, `value.rb`, `array.rb`, `object.rb`, `string.rb`, `number.rb`, `pair.rb`, `type.rb`.
  - Parsing is state-machine driven, with explicit modes for each JSON type.
  - Each type (array, object, string, number, etc.) has its own module and parse method.
- **bin/cli**: Command-line interface. Reads from STDIN, parses input, prints results.
- **api_grape/**: Grape API exposing `/api/v1/parse` endpoint. Uses the custom JSON parser for requests.
- **api_rails/**: Rails API exposing `/api/v1/parse` endpoint. Uses the custom JSON parser for requests. Minimal Rails 8.0.2 API-only app with security scanning via Brakeman.
- **api_roda/**: Roda API exposing `/api/v1/parse` endpoint. Uses the custom JSON parser for requests.
- **api_sinatra/**: Sinatra API exposing `/api/v1/parse` endpoint. Uses the custom JSON parser for requests.
- **spec/**: RSpec tests for all parser components. Use as reference for expected behaviors and edge cases.
- **testdata/**: Example REST requests for API testing (compatible with VS Code REST Client extension).

### Developer Workflows

See [README.md](../README.md) for detailed developer workflows and setup instructions.

### Project-Specific Conventions

- **API:** All APIs (Sinatra, Rails, Grape, Roda) and the CLI use the custom `JSONParser.parse` for parsing JSON requests.
- **Error Handling:** Syntax errors raise `SyntaxError` with descriptive messages. See RSpec tests for expected error cases.
- **Linting:** RuboCop is configured with custom rules; metrics cops are mostly disabled except for style and security.
- **Parsing:** All parsing is done via explicit state machines. Each type has a `Mode` enum and a `parse` method. See `lib/array.rb`, `lib/object.rb`, etc.
- **Testing:** RSpec is used; tests are organized by type/component. See `spec/` for examples.
- **Type System:** Types are defined in `lib/type.rb` and used throughout the parser for consistency.

### Integration Points & External Dependencies

- **CI:** GitHub Actions workflows in `.github/workflows/ci.yml` (main project tests on Ruby 3.3.9) and `.github/workflows/rails-ci.yml` (Rails API security scanning, linting, and health checks). Dependabot configured in `.github/dependabot.yml` for automated dependency updates.
- **Gems:** See `Gemfile` for dependencies (Sinatra, Grape, Roda, Puma, Rack, Rackup, Webrick, RSpec, RuboCop). Rails API uses Rails 8.0.2 with Brakeman for security scanning.
- **VS Code Extensions:** Recommended: Ruby Extensions Pack, Ruby LSP, Sorbet, REST Client (see `.vscode/extensions.json`).

### Notes

- **API and CLI use the same parser:** All APIs (Sinatra, Rails, Grape, Roda) and the CLI use the custom JSON parser.
- **Rails API:** Minimal API-only Rails 8.0.2 app. Uses Brakeman for security scanning and RuboCop with Rails-specific rules.
- **Test coverage:** SimpleCov is not supported due to Ruby 3.3.9 issues.

---

If any section is unclear or missing, please provide feedback for further refinement.
