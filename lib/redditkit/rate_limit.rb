module RedditKit

  # The class to rate-limit requests to reddit.
  class RateLimit
    # Time the last request was made.
    attr_reader :last_request

    def initialize
      @last_request = Time.at(0)
    end

    # Sleep until a given number of seconds have passed since the last request
    def wait(gap = 2)
      wait_time = @last_request + gap - Time.now
      sleep(wait_time) if wait_time > 0
      @last_request = Time.now
    end
  end
end
