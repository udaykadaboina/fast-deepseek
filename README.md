# FastDeepseek

[![Gem Version](https://badge.fury.io/rb/fast-deepseek.svg)](https://badge.fury.io/rb/fast-deepseek)

A Ruby client for the DeepSeek API.

## Installation

Add this line to your application's Gemfile:
`gem 'fast-deepseek'`

And then execute:
`bundle install`

Or install it yourself as:
`gem install fast-deepseek`

## Usage

Create a client with your DeepSeek API key:

```ruby
require 'fast_deepseek'

client = FastDeepseek::Client.new(api_key: 'YOUR_API_KEY')
```

### Chat completion

Send a simple prompt to a DeepSeek model:

```ruby
response = client.chat('Hello, how are you?', model: 'deepseek-chat')
content = client.message_content(response)
puts content
```

You can also pass a full OpenAI-compatible `messages` array:

```ruby
messages = [
  { role: 'user', content: 'Explain the difference between Ruby and Python.' }
]

response = client.chat(nil, model: 'deepseek-chat', messages: messages)
puts client.message_content(response)
```

### List available models

```ruby
models = client.models
puts models['data'].map { |m| m['id'] }
```

## Configuration

You can override the default DeepSeek API URL if needed:

```ruby
client = FastDeepseek::Client.new(
  api_key: 'YOUR_API_KEY',
  base_url: 'https://api.deepseek.com'
)
```

## Error Handling

The gem raises these custom exceptions:

- `FastDeepseek::Error`: generic request or response failure
- `FastDeepseek::RateLimitError`: API rate limit exceeded
- `FastDeepseek::ServerError`: upstream server error

Example:

```ruby
begin
  response = client.chat('Hello, how are you?', model: 'deepseek-chat')
rescue FastDeepseek::Error => e
  warn "API request failed: #{e.message}"
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/udaykadaboina/fast-deepseek.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FastDeepseek project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/udaykadaboina/fast-deepseek/blob/main/CODE_OF_CONDUCT.md).
