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
          if raw_text.nil?
            error!({ code: 400, message: "Request body is empty" }, 400)
          end
          result = JSON.parse(raw_text)
          status 200
          if result.nil? || result == false
            result
          else
            present result
          end
        rescue SyntaxError => e
          error!({ code: 400, message: e.message }, 400)
        end
      end
    end
  end
end
