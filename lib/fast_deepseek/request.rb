# frozen_string_literal: true

require "faraday"
require "json"
require "logger"
require_relative "errors"

module FastDeepseek
  # Handles HTTP requests and API response parsing.
  class Request
    def initialize(api_key:, base_url:, logger: nil)
      @api_key = api_key
      @logger = logger || Logger.new($stdout)
      @conn = Faraday.new(url: base_url) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers["Content-Type"] = "application/json"
      end
    end

    def call(endpoint, payload = nil, method: :post)
      response = send_request(endpoint, payload, method)
      handle_response(response)
    rescue Faraday::Error => e
      @logger.error("API request failed: #{e.message}")
      raise Error, "API request failed: #{e.message}"
    rescue JSON::ParserError => e
      @logger.error("Invalid API response: #{e.message}")
      raise Error, "Invalid API response: #{e.message}"
    end

    private

    def send_request(endpoint, payload, method)
      path = method == :post ? "#{endpoint}/completions" : endpoint
      @conn.public_send(method, path) do |req|
        req.headers["Authorization"] = format("Bearer %s", @api_key)
        req.body = payload.to_json if payload
      end
    end

    def handle_response(response)
      case response.status
      when 429
        @logger.error("API rate limit exceeded. Please try again later.")
        raise RateLimitError, "API rate limit exceeded. Please try again later."
      when 500..599
        @logger.error("Server error occurred. Please try again later.")
        raise ServerError, "Server error occurred. Please try again later."
      when 200..299
        JSON.parse(response.body)
      else
        @logger.error("API request failed: #{response.status} - #{response.body}")
        raise Error, "API request failed: #{response.status} - #{response.body}"
      end
    end
  end
end
