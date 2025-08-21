// ...existing code...

## AI Coding Agent Instructions for json-rb

### Project Overview

- This is a Ruby implementation of a JSON parser, ported from TypeScript. It includes a CLI, a Sinatra-based API, and a modular parser in `lib/`.
- The parser is custom and does not use Ruby's built-in `JSON` for parsing; see `lib/json.rb` and related files for the core logic.

### Architecture & Major Components

- **lib/**: Core parsing logic. Key modules: `json.rb`, `value.rb`, `array.rb`, `object.rb`, `string.rb`, `number.rb`, `pair.rb`, `type.rb`.
  - Parsing is state-machine driven, with explicit modes for each JSON type.
  - Each type (array, object, string, number, etc.) has its own module and parse method.
- **bin/cli**: Command-line interface. Reads from STDIN, parses input, prints results.
- **api_sinatra/**: Sinatra API exposing `/api/v1/parse` endpoint. Uses Ruby's built-in `JSONParser.parse` (not the custom parser) for requests.
- **spec/**: RSpec tests for all parser components. Use as reference for expected behaviors and edge cases.
- **testdata/**: Example REST requests for API testing (compatible with VS Code REST Client extension).

### Developer Workflows

- **Install dependencies:** `bundle install`
- **Run CLI:** `ruby bin/cli` (input JSON via STDIN)
- **Run tests:** `bundle exec rspec` (RSpec, see `.rspec` and `spec/spec_helper.rb`)
- **Lint/Format:** `bundle exec rubocop` and `bundle exec rubocop -x` (see `.rubocop.yml` for custom rules)
- **Run API server:** `rackup api_sinatra/config.ru -p 8000 -s webrick` (Sinatra, port 8000)
- **Run Roda API server:** `rackup api_roda/config.ru -p 8000 -s webrick` (Roda, port 8000)
- **Test API endpoints:** Use `.rest` files in `testdata/` with VS Code REST Client extension.

### Project-Specific Conventions

- **Parsing:** All parsing is done via explicit state machines. Each type has a `Mode` enum and a `parse` method. See `lib/array.rb`, `lib/object.rb`, etc.
- **Error Handling:** Syntax errors raise `SyntaxError` with descriptive messages. See RSpec tests for expected error cases.
- **Type System:** Types are defined in `lib/type.rb` and used throughout the parser for consistency.
- **Linting:** RuboCop is configured with custom rules; metrics cops are mostly disabled except for style and security.
- **Testing:** RSpec is used; tests are organized by type/component. See `spec/` for examples.
- **API:** The Sinatra API uses Ruby's built-in `JSONParser.parse`, not the custom parser. The CLI uses the custom parser.

### Integration Points & External Dependencies

- **Gems:** See `Gemfile` for dependencies (Sinatra, RSpec, RuboCop).
- **VS Code Extensions:** Recommended: Ruby LSP, REST Client, Sorbet (see `.vscode/extensions.json`).
- **CI:** GitHub Actions workflow in `.github/workflows/ci.yml` runs tests on Ruby 3.4.5.

### Examples

- **Parsing a JSON string:**
  ```ruby
  result = JSONParser.parse('{"a":1}')
  # => { skip: ..., token: { type: JSONParser::Type::OBJECT, members: [...] } }
  ```
- **Testing an array:** See `spec/array_spec.rb` for RSpec examples.
- **API request:** See `testdata/all.rest` for a sample POST request.

### Notes

- **Test coverage:** SimpleCov is not supported due to Ruby 3.4.5 issues.
- **API and CLI use different parsers.**

---

If any section is unclear or missing, please provide feedback for further refinement.
