# FastDeepseek Roadmap

This roadmap describes the planned evolution of the FastDeepseek Ruby client.

## Available Now

- Ruby 3.2 and newer support
- Hosted DeepSeek API access
- API-key authentication through an argument or `DEEPSEEK_API_KEY`
- Configurable API base URL for compatible endpoints
- Non-streaming chat completions
- Configurable model and request options
- Namespaced errors for general failures, rate limits, and server errors
- Dotenv support for local development

## In Progress

### Model Discovery

Expose the DeepSeek `/models` endpoint through `Client#models` so applications can inspect the models available to their API key.

Example:

```ruby
models = client.models
models.fetch("data").each do |model|
  puts model.fetch("id")
end
```

## Planned Features

### 1. Streaming Chat Responses

Allow callers to process response tokens as they arrive from the API.

- Add a streaming chat API with a block or enumerable interface
- Parse server-sent event chunks
- Expose text deltas and the final response metadata
- Handle interrupted and malformed streams consistently

### 2. Configurable Timeouts and Retries

Improve behavior on slow or temporarily unavailable networks.

- Connection and request timeout settings
- Configurable retry count
- Exponential backoff for transient failures
- Retry network errors and appropriate `5xx` responses
- Preserve existing rate-limit behavior unless explicitly configured otherwise

### 3. Conversation History

Support multi-turn conversations without requiring callers to construct message payloads manually.

- Accept ordered message history
- Preserve system, user, and assistant roles
- Keep the existing single-prompt `chat` API compatible
- Validate message structure before making a request

### 4. Response and Request Ergonomics

Make common API operations easier to use while keeping raw response access available.

- Small response objects or helpers for choices, content, usage, and model metadata
- Consistent request option handling across endpoints
- Clear validation errors for missing or invalid arguments
- Optional structured logging hooks

### 5. Expanded API Coverage

Add commonly used DeepSeek endpoints as stable client methods.

- Model metadata helpers
- Token usage and response metadata access
- Embeddings, when supported by the target DeepSeek API
- Additional compatible OpenAI-style endpoints as demand justifies them

### 6. Production Readiness

Strengthen the gem for use in services and applications.

- Integration tests for configurable endpoints
- Tests for streaming, retries, malformed responses, and timeouts
- CI coverage across supported Ruby versions
- Documented compatibility and upgrade guidance
- Semantic versioning and changelog entries for public API changes

## Priorities

The recommended implementation order is:

1. Model discovery
2. Streaming chat responses
3. Configurable timeouts and retries
4. Conversation history
5. Response ergonomics
6. Expanded API coverage and production hardening
