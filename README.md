# FastDeepseek

A Ruby client for the DeepSeek API.

## Installation

Add this line to your application's Gemfile:
`gem 'fast-deepseek'`

And then execute:
`bundle install`

Or install it yourself as:
`gem install fast-deepseek`

## Usage

To use the FastDeepseek client, you'll need to create an instance of the `FastDeepseek::Client` class, passing in your DeepSeek API key. Please refer [DeepSeek Platform API keys](https://platform.deepseek.com/api_keys) page to obtain your API key.

```Ruby
require 'fast_deepseek'

client = FastDeepseek::Client.new(api_key: 'YOUR_API_KEY')
```

You can then use the `#chat` and `#coder` methods to send requests to the DeepSeek API:
```Ruby
response = client.chat('Hello, world!')
puts response

response = client.coder('Write a Python function to calculate the factorial of a number.')
puts response
```
## Configuration

You can configure the `FastDeepseek::Client` instance by passing in additional options:
```Ruby
client = FastDeepseek::Client.new(
  api_key: 'YOUR_API_KEY',
  base_url: 'https://api.deepseek.com'
)
```
## Error Handling

The FastDeepseek client raises custom error classes for different types of errors:

`DeepSeek::Error`: a generic error class for API request failures.
`DeepSeek::RateLimitError`: raised when the API rate limit is exceeded.
`DeepSeek::ServerError`: raised when a server error occurs.
You can rescue these errors in your code to handle them accordingly:

```Ruby
begin
  response = client.chat('Hello, world!')
rescue DeepSeek::Error => e
  puts "API request failed: #{e.message}"
end
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/udaykadaboina/fast-deepseek.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct
Everyone interacting in the FastDeepseek project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/udaykadaboina/fast-deepseek/blob/main/CODE_OF_CONDUCT.md).
