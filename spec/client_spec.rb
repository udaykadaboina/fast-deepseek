require 'spec_helper'

describe FastDeepseek::Client do
  let(:api_key) { 'test_api_key' }
  let(:client) { FastDeepseek::Client.new(api_key: api_key) }
  let(:base_url) { 'https://api.deepseek.com/' }

  describe '#chat' do
    it 'sends a chat request to the DeepSeek API' do
      stub_request(:post, 'http://localhost:11434/api/chat')
        .with(body: { model: 'deepseek-r1:1.5b', messages: [{ role: 'user', content: 'Hello, world!' }], stream: false }.to_json)
        .to_return(status: 200, body: { message: 'Hello, world!' }.to_json)

      response = client.chat('Hello, world!')

      expect(response.transform_keys(&:to_sym)).to eq({ message: 'Hello, world!' })
    end
  end

  describe '#coder' do
    it 'sends a code generation request to the DeepSeek API' do
      stub_request(:post, 'http://localhost:11434/api/chat')
        .with(body: { model: 'deepseek-coder', messages: [{ role: 'user', content: 'Write a Python function to calculate the factorial of a number.' }], stream: false }.to_json)
        .to_return(status: 200, body: { code: 'def factorial(n): return n * factorial(n-1) if n > 1 else 1' }.to_json)

      response = client.coder('Write a Python function to calculate the factorial of a number.')

      expect(response.transform_keys(&:to_sym)).to eq({ code: 'def factorial(n): return n * factorial(n-1) if n > 1 else 1' })
    end
  end
end