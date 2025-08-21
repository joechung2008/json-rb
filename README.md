# json.rb

JSON parser ported from TypeScript to Ruby 3.4.5

## License

MIT

## Reference

[json.org](http://json.org)

# Commands

## Install dependencies

Install all required gems for the project:

```sh
bundle install
```

## Run the CLI

Start the command-line interface for this library:

```sh
ruby bin/cli
```

## Lint with RuboCop

Check your Ruby code for style and quality issues:

```sh
bundle exec rubocop
```

## Format Ruby code with RuboCop

Automatically format your Ruby code to follow community standards:

```sh
bundle exec rubocop -x
```

## Test with RSpec

Run the test suite to verify your code works as expected:

```sh
bundle exec rspec
```

**Note:** This project is unable to use SimpleCov for test coverage reporting due to a known issue with `JSON.dump` in Ruby 3.4.5.  
See: https://github.com/rubygems/rubygems/issues/8927

## Run the Sinatra API

Start the Sinatra-based API server:

```sh
rackup api_sinatra/config.ru -p 8000
```

The API will be available at [http://localhost:8000](http://localhost:8000) by default.

## Test API endpoints with REST Client (VS Code Extension)

You can use the [REST Client extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) in VS Code to send requests to the API servers.

1. Create a `.rest` file (see `testdata/` for examples).
2. Add a request, for example:

```http
POST http://localhost:8000/api/v1/parse
Content-Type: application/json

{
  "foo": "bar"
}
```

3. Click "Send Request" above the request in VS Code to see the response.
