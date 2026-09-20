## [0.2.0] - 2026-09-19

- Document Ruby 3.2+ as the supported runtime range
- Use the hosted DeepSeek API by default instead of local Ollama
- Send requests to the `/chat/completions` endpoint with bearer authentication

- Fixed duplicate requests made by `Client#chat`
- Added namespaced API error classes
- Declared `dotenv` as a runtime dependency

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
