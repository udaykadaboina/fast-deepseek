# FastDeepseek

[![Gem Version](https://badge.fury.io/rb/fast-deepseek.svg)](https://badge.fury.io/rb/fast-deepseek)

A Ruby client for the hosted DeepSeek API.

Ruby 3.2 and newer are supported. Ruby 2.x is not supported.

## Installation

Add `gem 'fast-deepseek'` to your application's Gemfile and run `bundle install`,
or install it directly with `gem install fast-deepseek`.

## Usage

Create a client with a DeepSeek API key from the
[DeepSeek Platform](https://platform.deepseek.com/api_keys):

```ruby
require "fast_deepseek"

client = FastDeepseek::Client.new(api_key: ENV.fetch("DEEPSEEK_API_KEY"))
response = client.chat("Hello, how are you?", model: "deepseek-chat")

puts response["choices"].first["message"]["content"]
```

The client uses `https://api.deepseek.com` by default and sends requests to
DeepSeek's `/chat/completions` endpoint. A custom compatible endpoint can be
provided with `base_url`.

```ruby
client = FastDeepseek::Client.new(
  api_key: ENV.fetch("DEEPSEEK_API_KEY"),
  base_url: "https://api.deepseek.com"
)
```

Additional request options can be passed through `options`:

```ruby
client.chat(
  "Explain recursion",
  model: "deepseek-chat",
  options: { temperature: 0.7, max_tokens: 200 }
)
```

## Error Handling

The client raises `FastDeepseek::Error` for request failures,
`FastDeepseek::RateLimitError` for HTTP 429 responses, and
`FastDeepseek::ServerError` for HTTP 5xx responses.

```ruby
begin
  client.chat("Hello!", model: "deepseek-chat")
rescue FastDeepseek::Error => e
  warn "API request failed: #{e.message}"
end
```

## Contributing

Bug reports and pull requests are welcome at
https://github.com/udaykadaboina/fast-deepseek.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting with the FastDeepseek project is expected to follow the
[code of conduct](https://github.com/udaykadaboina/fast-deepseek/blob/main/CODE_OF_CONDUCT.md).
