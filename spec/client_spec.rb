require 'spec_helper'

RSpec.describe FastDeepseek::Client do
  let(:api_key) { 'test_api_key' }
  let(:client) { FastDeepseek::Client.new(api_key: api_key) }
  let(:base_url) { 'https://api.deepseek.com' }

  describe '#initialize' do
    it 'uses the DeepSeek API host by default' do
      expect(client.instance_variable_get(:@base_url)).to eq(base_url)
    end
  end

  describe '#chat' do
    it 'sends a single chat completion request to the DeepSeek API' do
      stub_request(:post, 'https://api.deepseek.com/chat/completions')
        .with(
          headers: { 'Authorization' => 'Bearer test_api_key' },
          body: { model: 'deepseek-chat', messages: [{ role: 'user', content: 'Hello, world!' }],
                  stream: false }.to_json
        )
        .to_return(status: 200, body: { choices: [{ message: { role: 'assistant',
                                                               content: 'Hello, world!' } }] }.to_json)

      response = client.chat('Hello, world!', model: 'deepseek-chat')

      expect(response['choices'].first['message']['content']).to eq('Hello, world!')
    end

    it 'accepts an explicit messages array for DeepSeek-compatible payloads' do
      messages = [{ role: 'user', content: 'Hello from a custom message list' }]

      stub_request(:post, 'https://api.deepseek.com/chat/completions')
        .with(
          headers: { 'Authorization' => 'Bearer test_api_key' },
          body: { model: 'deepseek-chat', messages: messages, stream: false }.to_json
        )
        .to_return(status: 200, body: { choices: [{ message: { role: 'assistant',
                                                               content: 'Hi there!' } }] }.to_json)

      response = client.chat(nil, model: 'deepseek-chat', messages: messages)

      expect(client.message_content(response)).to eq('Hi there!')
    end
  end

  describe '#coder' do
    it 'sends a code generation request to the DeepSeek API' do
      stub_request(:post, 'https://api.deepseek.com/chat/completions')
        .with(
          headers: { 'Authorization' => 'Bearer test_api_key' },
          body: { model: 'deepseek-coder',
                  messages: [{ role: 'user', content: 'Write a Python function to calculate the factorial of a number.' }], stream: false }.to_json
        )
        .to_return(status: 200, body: { choices: [{ message: { role: 'assistant',
                                                               content: 'def factorial(n): return n * factorial(n - 1) if n > 1 else 1' } }] }.to_json)

      response = client.chat('Write a Python function to calculate the factorial of a number.', model: 'deepseek-coder')

      expect(response['choices'].first['message']['content']).to include('def factorial')
    end
  end
end
