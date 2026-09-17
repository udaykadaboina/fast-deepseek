## [Unreleased]

## [0.2.0] - 2026-09-17

- Switched the default API base URL to the official DeepSeek endpoint
- Fixed the chat request flow to use a single DeepSeek chat completion request
- Added DeepSeek-compatible `messages` payload support while keeping prompt-based usage working
- Added `models` endpoint to list available models
- Added consistent custom error classes for rate limits, server failures, and generic API errors
- Updated README usage examples to match the actual public API

## [0.1.3] - 2025-03-26

- Fixed minor bug in gemspec metadata

## [0.1.2] - 2025-03-26

- Updated usage examples in README
- Fixed gemspec to reflect the changes in rubygems.org

## [0.1.1] - 2025-02-21

- Use dotenv for storing API key in env vars
- Merge `chat` & `coder` methods by allowing users to pass `:model`

## [0.1.0] - 2025-02-21

- Initial release
