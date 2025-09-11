require "test_helper"

module Api
  module V1
    class ParseControllerTest < ActionController::TestCase
      test "should parse valid JSON successfully" do
        post :create, body: '{"key": "value"}', as: :text

        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal 5, json_response["type"] # OBJECT
        assert json_response["members"].present?
      end

      test "should return 415 for invalid content type" do
        post :create, params: { data: '{"key": "value"}' }

        assert_response :unsupported_media_type
        json_response = JSON.parse(response.body)
        assert_equal 415, json_response["code"]
        assert_equal "Invalid Media Type", json_response["message"]
      end

      test "should return 400 for invalid JSON syntax" do
        post :create, body: '{"invalid": json}', as: :text

        assert_response :bad_request
        json_response = JSON.parse(response.body)
        assert_equal 400, json_response["code"]
        assert json_response["message"].present?
      end

      test "should parse array JSON successfully" do
        post :create, body: "[1, 2, 3]", as: :text

        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal 1, json_response["type"] # ARRAY
        assert json_response["value"].present?
      end

      test "should parse string JSON successfully" do
        post :create, body: '"hello world"', as: :text

        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal 7, json_response["type"] # STRING
        assert_equal "hello world", json_response["value"]
      end

      test "should parse number JSON successfully" do
        post :create, body: "42", as: :text

        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal 4, json_response["type"] # NUMBER
        assert_equal 42, json_response["value"]
      end

      test "should parse boolean JSON successfully" do
        post :create, body: "true", as: :text

        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal 8, json_response["type"] # TRUE
        assert_equal true, json_response["value"]
      end

      test "should parse null JSON successfully" do
        post :create, body: "null", as: :text

        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal 3, json_response["type"] # NULL
      end

      test "should handle empty request body" do
        post :create, body: "", as: :text

        assert_response :bad_request
        json_response = JSON.parse(response.body)
        assert_equal 400, json_response["code"]
        assert json_response["message"].present?
      end
    end
  end
end
