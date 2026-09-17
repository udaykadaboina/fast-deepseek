require 'faraday'
require 'json'
require 'logger'
require 'dotenv/load'

module FastDeepseek
  class Error < StandardError; end
  class RateLimitError < Error; end
  class ServerError < Error; end

  class Client
    DEFAULT_HOST = 'https://api.deepseek.com'.freeze

    def initialize(api_key: nil, base_url: DEFAULT_HOST)
      @api_key = api_key || ENV.fetch('DEEPSEEK_API_KEY', nil)
      raise 'DEEPSEEK_API_KEY is missing! Set it in the .env file or pass it explicitly.' unless @api_key

      @base_url = base_url
      @logger = Logger.new($stdout)

      @conn = Faraday.new(url: base_url) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
      end
    end

    def chat(prompt = nil, model:, messages: nil, options: {})
      raise ArgumentError, 'Either prompt or messages must be provided.' if prompt.nil? && messages.nil?

      request({
        model: model,
        messages: messages || [{ role: 'user', content: prompt }],
        stream: false
      }.merge(options))
    end

    def message_content(response)
      response.dig('choices', 0, 'message', 'content') || response.dig('message', 'content')
    end

    private

    def request(payload)
      response = @conn.post('/chat/completions') do |req|
        req.headers['Authorization'] = "Bearer #{@api_key}"
        req.body = JSON.dump(payload)
      end

      handle_response(response)
    rescue Faraday::Error => e
      @logger.error("API request failed: #{e.message}")
      raise FastDeepseek::Error, "API request failed: #{e.message}"
    end

    def handle_response(response)
      case response.status
      when 429
        @logger.error('API rate limit exceeded. Please try again later.')
        raise FastDeepseek::RateLimitError, 'API rate limit exceeded. Please try again later.'
      when 500..599
        @logger.error('Server error occurred. Please try again later.')
        raise FastDeepseek::ServerError, 'Server error occurred. Please try again later.'
      when 200
        JSON.parse(response.body)
      else
        @logger.error("API request failed: #{response.status} - #{response.body}")
        raise FastDeepseek::Error, "API request failed: #{response.status} - #{response.body}"
      end
    end
  end
end
