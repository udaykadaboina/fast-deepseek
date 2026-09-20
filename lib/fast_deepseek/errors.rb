# frozen_string_literal: true

module FastDeepseek
  class Error < StandardError; end

  class RateLimitError < Error; end

  class ServerError < Error; end
end
