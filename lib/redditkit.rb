require 'redditkit/client'

# The main RedditKit module.
module RedditKit
  class << self

    # A RedditKit::Client, used when calling methods on the RedditKit module itself.
    #
    # @return [RedditKit::Client]
    def client
      @client ||= RedditKit::Client.new
    end

    def respond_to?(method_name, include_private = false)
      client.respond_to?(method_name, include_private) || super
    end

    private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end
end
