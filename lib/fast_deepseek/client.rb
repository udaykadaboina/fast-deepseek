# frozen_string_literal: true

require "faraday"
require "json"
require "logger"
require "dotenv/load"

module FastDeepseek
  # Client for interacting with the DeepSeek API.
  class Client
    DEFAULT_HOST = "https://api.deepseek.com"

    def initialize(api_key: nil, base_url: DEFAULT_HOST)
      @api_key = api_key || ENV.fetch("DEEPSEEK_API_KEY", nil)
      raise Error, "DEEPSEEK_API_KEY is missing! Set it in the .env file or pass it explicitly." unless @api_key

      @logger = Logger.new($stdout)
      @conn = Faraday.new(url: base_url) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers["Content-Type"] = "application/json"
      end
    end

    def chat(prompt, model:, options: {})
      request("chat", { model: model, messages: [{ role: "user", content: prompt }], stream: false }.merge(options))
    end

    private

    def request(endpoint, payload)
      response = @conn.post("#{endpoint}/completions") do |req|
        req.headers["Authorization"] = "Bearer #{@api_key}"
        req.body = payload.to_json
      end

      handle_response(response)
    rescue Faraday::Error => e
      @logger.error("API request failed: #{e.message}")
      raise Error, "API request failed: #{e.message}"
    rescue JSON::ParserError => e
      @logger.error("Invalid API response: #{e.message}")
      raise Error, "Invalid API response: #{e.message}"
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
