=begin

RawBodySaver is a Rack middleware to work around the issue of
`env['rack.input'].read` returning `nil` in Grape.

=end
class RawBodySaver
    def initialize(app)
      @app = app
    end

    def call(env)
      input = env['rack.input']
      raw_body = input.respond_to?(:read) ? input.read : nil
      env['raw.body'] = raw_body
      input.rewind if input.respond_to?(:rewind)
      @app.call(env)
    end
end
