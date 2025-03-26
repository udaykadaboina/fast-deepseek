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

To use the FastDeepseek client, you'll need to create an instance of the `FastDeepseek::Client` class, passing in your DeepSeek API key. Please refer [DeepSeek Platform API keys](https://platform.deepseek.com/api_keys) page to obtain your API key.

```Ruby
require 'fast_deepseek'

client = FastDeepseek::Client.new(api_key: 'YOUR_API_KEY')
```

You can then use the `#chat` method with desired `:model` to send requests to the DeepSeek API:

```Ruby
irb(main):001> require 'fast_deepseek'
=> true
irb(main):002> client = FastDeepseek::Client.new(api_key: 'NO-KEY-LOCAL-MODEL')
irb(main):003> client.chat('Hello, how are you?', model: 'deepseek-r1:1.5b')
=> 
{"model"=>"deepseek-r1:1.5b",
 "created_at"=>"2025-03-26T15:45:15.161158Z",
 "message"=>
  {"role"=>"assistant",
   "content"=>
    "<think>\n\n</think>\n\nHi! I'm just a virtual assistant, so I don't have feelings, but I'm here and ready to help you with whatever you need. How can I assist you today? 😊"},
 "done_reason"=>"stop",
 "done"=>true,
 "total_duration"=>503968959,
 "load_duration"=>9845042,
 "prompt_eval_count"=>9,
 "prompt_eval_duration"=>11000000,
 "eval_count"=>44,
 "eval_duration"=>482000000}

```

```Ruby
irb(main):007> client.chat('Write a Python function to calculate the factorial of a number.', model: 'deepseek-coder')
=> 
{"model"=>"deepseek-coder",
 "created_at"=>"2025-03-26T15:47:45.531275Z",
 "message"=>
  {"role"=>"assistant",
   "content"=>
    "Sure! Here is an implementation in python for calculating the factorial using recursion or iteration approach (both are common ways). In this example I am going with Iteration method as it's simpler and more understandable, but you can use either if your preference on doing so :) \nHere we go.\n\n```python\ndef calculate_factorial(n):  \n    result = 1 # Initialization of the variable to store factorial value      \n    \n    for i in range (2 , n + 1) :       \n         print (\"Value before assignment: \",result, \"In loop\") \n          \n         \"\"\" Here we are using method and reassigning it with formula. This is an example showing how you can use the multiplication symbol '*' to multiply a number repeatedly from start till end.\"\"\"   # explanation inside this comment for better understanding of code    \n          result *= i; print (\"Value after assignment: \",result, \"In loop\")         return (int(float(\"%.2f\" % pow(n , n - int(pow((abs(i),0.67))-1)/ abs(factorial_of_numbers[-1])))))\n```       This function `calculate_Factorial` takes a number as argument and returns the factorial of that given no (for example, calculate fact if 5 is passed). It uses an iterative approach to find out product upto n. In each iteration it multiplies result with current loop counter i which goes from start(2) till end user entered value .\n"},
 "done_reason"=>"stop",
 "done"=>true,
 "total_duration"=>2431652375,
 "load_duration"=>3594333,
 "prompt_eval_count"=>82,
 "prompt_eval_duration"=>7000000,
 "eval_count"=>330,
 "eval_duration"=>2419000000}

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
  response = client.chat('Hello, how are you?', model: 'deepseek-r1:1.5b')
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
