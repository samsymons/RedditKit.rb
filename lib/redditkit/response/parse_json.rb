require 'faraday'
require 'multi_json'

module RedditKit

  # Methods for handling responses from reddit.
  module Response
    class ParseJSON < Faraday::Response::Middleware

      # Turn the response body into a JSON object.
      #
      # @note Because the reddit API sometimes returns invalid JSON objects with
      #   an application/json header, we want to return the body itself if the
      #   JSON parsing fails, because the response is still likely useful.
      def parse(body)
        MultiJson.load(body, :symbolize_keys => true) unless body.nil?
      rescue MultiJson::LoadError
        body
      end

      def on_complete(env)
        if respond_to?(:parse)
          unless bad_status_codes.include? env[:status]
            env[:body] = parse env[:body]
          end
        end
      end

      def bad_status_codes
        @status_codes ||= [204, 301, 302, 304]
      end

    end
  end
end
