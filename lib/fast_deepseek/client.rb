# lib/fast_deepseek/client.rb
require 'faraday'
require 'json'
require 'logger'

module FastDeepseek
  class Client
    DEFAULT_HOST = 'http://localhost:11434/api'.freeze

    def initialize(api_key:, base_url: DEFAULT_HOST)
      @api_key = api_key || ENV['DEEPSEEK_API_KEY']
      @base_url = base_url
      @logger = Logger.new($stdout)

      @conn = Faraday.new(url: base_url) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
      end
    end

    def chat(prompt, model: 'deepseek-r1:1.5b', options: {})
      request('chat', { model: model, messages: [{ role: 'user', content: prompt }], stream: false }.merge(options))
    end

    def coder(prompt, model: 'deepseek-coder')
      request('chat', { model: model, messages: [{ role: 'user', content: prompt }], stream: false })
    end

    private

    def request(endpoint, payload)
      response = @conn.post("/api/#{endpoint}", payload.to_json)

      response = @conn.post(endpoint) do |req|
        req.headers['Authorization'] = "Bearer #{@api_key}"
        req.body = JSON.dump(payload)
      end

      handle_response(response)
    rescue Faraday::Error => e
      @logger.error("API request failed: #{e.message}")
      raise DeepSeek::Error, "API request failed: #{e.message}"
      JSON.parse(response.body)
    end

    def handle_response(response)
      case response.status
      when 429
        @logger.error('API rate limit exceeded. Please try again later.')
        raise DeepSeek::RateLimitError, 'API rate limit exceeded. Please try again later.'
      when 500..599
        @logger.error('Server error occurred. Please try again later.')
        raise DeepSeek::ServerError, 'Server error occurred. Please try again later.'
      when 200
        JSON.parse(response.body)
      else
        @logger.error("API request failed: #{response.status} - #{response.body}")
        raise DeepSeek::Error, "API request failed: #{response.status} - #{response.body}"
      end
    end
  end
end
