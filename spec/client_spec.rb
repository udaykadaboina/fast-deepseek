# frozen_string_literal: true

require "spec_helper"

RSpec.describe FastDeepseek::Client do
  let(:api_key) { "test_api_key" }
  let(:client) { FastDeepseek::Client.new(api_key: api_key) }
  let(:endpoint) { "https://api.deepseek.com/chat/completions" }

  describe "#chat" do
    it "sends a chat request to the DeepSeek API" do
      stub_request(:post, endpoint)
        .with(
          body: { model: "deepseek-chat", messages: [{ role: "user", content: "Hello, world!" }],
                  stream: false }.to_json,
          headers: { "Authorization" => "Bearer #{api_key}" }
        )
        .to_return(status: 200, body: { choices: [{ message: { content: "Hello, world!" } }] }.to_json)

      response = client.chat("Hello, world!", model: "deepseek-chat")

      expect(response["choices"].first["message"]["content"]).to eq("Hello, world!")
    end

    it "raises a rate limit error for a 429 response" do
      stub_request(:post, endpoint).to_return(status: 429, body: "rate limited")

      expect { client.chat("Hello, world!", model: "deepseek-chat") }
        .to raise_error(FastDeepseek::RateLimitError, /rate limit exceeded/)
    end

    it "raises a server error for a 5xx response" do
      stub_request(:post, endpoint).to_return(status: 503, body: "unavailable")

      expect { client.chat("Hello, world!", model: "deepseek-chat") }
        .to raise_error(FastDeepseek::ServerError, /Server error/)
    end

    it "makes one request per chat call" do
      request = stub_request(:post, endpoint).to_return(
        status: 200, body: { choices: [{ message: { content: "Hello, world!" } }] }.to_json
      )

      client.chat("Hello, world!", model: "deepseek-chat")

      expect(request).to have_been_requested.once
    end
  end

  describe "code generation" do
    it "sends a code generation request to the DeepSeek API" do
      stub_request(:post, endpoint)
        .with(body: { model: "deepseek-chat",
                      messages: [{ role: "user",
                                   content: "Write a Python function to calculate the factorial of a number." }],
                      stream: false }.to_json)
        .to_return(status: 200, body: { choices: [{ message: { content: "def factorial(n): ..." } }] }.to_json)

      response = client.chat("Write a Python function to calculate the factorial of a number.",
                             model: "deepseek-chat")

      expect(response["choices"].first["message"]["content"]).to eq("def factorial(n): ...")
    end
  end
end
