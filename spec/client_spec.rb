# frozen_string_literal: true

require "spec_helper"

RSpec.describe FastDeepseek::Client do
  let(:api_key) { "test_api_key" }
  let(:client) { FastDeepseek::Client.new(api_key: api_key) }
  let(:base_url) { "https://api.deepseek.com/" }

  describe "#chat" do
    it "sends a chat request to the DeepSeek API" do
      stub_request(:post, "http://localhost:11434/api/chat")
        .with(body: { model: "deepseek-r1:1.5b", messages: [{ role: "user", content: "Hello, world!" }],
                      stream: false }.to_json)
        .to_return(status: 200, body: { message: "Hello, world!" }.to_json)

      response = client.chat("Hello, world!", model: "deepseek-r1:1.5b")

      expect(response.transform_keys(&:to_sym)).to eq({ message: "Hello, world!" })
    end

    it "raises a rate limit error for a 429 response" do
      stub_request(:post, "http://localhost:11434/api/chat")
        .to_return(status: 429, body: "rate limited")

      expect { client.chat("Hello, world!", model: "deepseek-r1:1.5b") }
        .to raise_error(FastDeepseek::RateLimitError, /rate limit exceeded/)
    end

    it "raises a server error for a 5xx response" do
      stub_request(:post, "http://localhost:11434/api/chat")
        .to_return(status: 503, body: "unavailable")

      expect { client.chat("Hello, world!", model: "deepseek-r1:1.5b") }
        .to raise_error(FastDeepseek::ServerError, /Server error/)
    end

    it "makes one request per chat call" do
      request = stub_request(:post, "http://localhost:11434/api/chat").to_return(
        status: 200, body: { message: "Hello, world!" }.to_json
      )

      client.chat("Hello, world!", model: "deepseek-r1:1.5b")

      expect(request).to have_been_requested.once
    end
  end

  describe "#coder" do
    it "sends a code generation request to the DeepSeek API" do
      stub_request(:post, "http://localhost:11434/api/chat")
        .with(body: { model: "deepseek-coder",
                      messages: [{ role: "user",
                                   content: "Write a Python function to calculate the factorial of a number." }],
                      stream: false }.to_json)
        .to_return(status: 200, body: { code: "def factorial(n): return n * factorial(n-1) if n > 1 else 1" }.to_json)

      response = client.chat("Write a Python function to calculate the factorial of a number.",
                             model: "deepseek-coder")

      expect(response.transform_keys(&:to_sym)).to eq(
        { code: "def factorial(n): return n * factorial(n-1) if n > 1 else 1" }
      )
    end
  end
end
