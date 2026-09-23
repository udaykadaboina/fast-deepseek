# frozen_string_literal: true

require "dotenv/load"
require_relative "request"

module FastDeepseek
  # Client for interacting with the DeepSeek API.
  class Client
    DEFAULT_HOST = "https://api.deepseek.com"

    def initialize(api_key: nil, base_url: DEFAULT_HOST)
      @api_key = api_key || ENV.fetch("DEEPSEEK_API_KEY", nil)
      raise Error, "DEEPSEEK_API_KEY is missing! Set it in the .env file or pass it explicitly." unless @api_key

      @request = Request.new(api_key: @api_key, base_url: base_url)
    end

    def chat(prompt, model:, options: {})
      payload = { model: model, messages: [{ role: "user", content: prompt }], stream: false }.merge(options)
      @request.call("chat", payload)
    end

    def models
      @request.call("models", method: :get)
    end
  end
end
