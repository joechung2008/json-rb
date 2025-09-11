require "json_rb"

module Api
  module V1
    class ParseController < ActionController::API
      def create
        # Check content type
        unless request.content_type == "text/plain"
          render json: { code: 415, message: "Invalid Media Type" }, status: :unsupported_media_type
          return
        end

        # Read request body
        json_input = request.body.read

        begin
          # Parse with custom JSON parser
          result = JSONParser.parse(json_input)
          # Return the token as JSON
          render json: result[:token]
        rescue SyntaxError => e
          render json: { code: 400, message: e.message }, status: :bad_request
        end
      end
    end
  end
end
