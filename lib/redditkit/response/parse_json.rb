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
        MultiJson.load(body, :symbolize_names => true) unless body.nil?
      rescue MultiJson::LoadError
        body
      end

      def on_complete(env)
        if respond_to?(:parse)
          env[:body] = parse(env[:body]) unless [204, 301, 302, 304].include?(env[:status])
        end
      end

    end
  end
end
