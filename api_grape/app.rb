require_relative '../lib/json'
require 'json'
require 'grape'

class ParseAPI < Grape::API
  format :json

  content_type :txt, "text/plain"

  namespace :api do
    namespace :v1 do
      desc 'Parse JSON from plain text', consumes: ['text/plain'], produces: ['application/json']
      params do
        # No params, raw body only
      end
      post :parse do
        begin
          raw_text = env['raw.body']
          result = JSONParser.parse(raw_text)
          status 200
          result
        rescue SyntaxError => e
          error!({ code: 400, message: e.message }, 400)
        end
      end
    end
  end
end
