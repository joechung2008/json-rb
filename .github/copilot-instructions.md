# Copilot Instructions for json-rb

This guide provides essential knowledge for AI coding agents working in the `json-rb` Ruby project. Follow these conventions and workflows to be immediately productive.

## Project Overview

- **Purpose:** Ruby 3.4.5 port of a TypeScript JSON parser. See [json.org](http://json.org) for reference.
- **Architecture:**
  - Core parsing logic is split across `lib/` files: `json.rb`, `array.rb`, `object.rb`, `string.rb`, `number.rb`, `pair.rb`, `type.rb`, `value.rb`.
  - Each file implements a distinct JSON type or parsing responsibility. For example, `array.rb` handles JSON arrays, `object.rb` handles objects, etc.
  - The CLI entry point is `bin/cli`.
- **Testing:** All specs are in `spec/` and use RSpec. Each core file has a corresponding spec file (e.g., `lib/array.rb` → `spec/array_spec.rb`).

## Developer Workflows

- **Install dependencies:**
  - `bundle install`
- **Run CLI:**
  - `ruby bin/cli`
- **Lint and format:**
  - Lint: `bundle exec rubocop`
  - Auto-format: `bundle exec rubocop -x`
- **Run tests:**
  - `bundle exec rspec`
  - Coverage reporting via SimpleCov is disabled due to Ruby 3.4.5 issues (see README).

## Project-Specific Conventions

- **File structure:**
  - Each JSON type is implemented in its own file under `lib/`.
  - Tests mirror the structure of `lib/` in `spec/`.
- **Error handling:**
  - Parsing errors are handled within each type's implementation. See `lib/value.rb` and `lib/type.rb` for error propagation patterns.
- **External dependencies:**
  - Only standard Ruby gems and RSpec are used. No external JSON libraries.
- **CLI:**
  - The CLI in `bin/cli` demonstrates usage and can be extended for custom commands.

## Integration Points

- **Extending parser:**
  - Add new types by creating a new file in `lib/` and a matching spec in `spec/`.
  - Update `lib/json.rb` to integrate new types.
- **Debugging:**
  - Use RSpec for test-driven debugging. Add failing specs to reproduce issues.

## Examples

- To parse a JSON string, see usage in `spec/json_spec.rb`.
- To add a new JSON type, follow the pattern in `lib/array.rb` and `spec/array_spec.rb`.

---

For more details, see the [README.md](../README.md).
