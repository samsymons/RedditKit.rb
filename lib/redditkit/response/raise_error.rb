require 'faraday'
require 'redditkit/error'

module RedditKit

  # Methods for handling responses from reddit.
  module Response
    class RaiseError < Faraday::Response::Middleware

      def on_complete(env)
        status_code = env[:status]
        body = env[:body]

        if error = RedditKit::Error.from_status_code_and_body(status_code, body)
          raise error
        end
      end

    end
  end
end
