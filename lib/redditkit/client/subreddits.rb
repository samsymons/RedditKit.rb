require 'redditkit/subreddit'

module RedditKit
  class Client

    # Methods for interacting with subreddits.
    module Subreddits

      # Gets subreddits from a specified category.
      #
      # @option options [new, popular, banned] category The category of subreddits. Defaults to popular.
      # @option options [1..100] limit The number of subreddits to return.
      # @option options [String] before Only return subreddits before this id.
      # @option options [String] after Only return subreddits after this id.
      # @return [RedditKit::PaginatedResponse]
      def subreddits(options = {})
        category = options[:category] or 'popular'
        path = "reddits/#{category}.json"
        options.delete :category

        objects_from_response(:get, path, options)
      end

      # Gets the current user's subscribed subreddits.
      #
      # @option options [subscriber, contributor, moderator] category The category from which to return subreddits. Defaults to subscriber.
      # @option options [1..100] limit The number of subreddits to return.
      # @option options [String] before Only return subreddits before this id.
      # @option options [String] after Only return subreddits after this id.
      # @return [RedditKit::PaginatedResponse]
      def subscribed_subreddits(options = {})
        category = options[:category] or 'subscriber'
        path = "subreddits/mine/#{category}.json"
        options.delete :category

        objects_from_response(:get, path, options)
      end

      # Gets a subreddit object.
      #
      # @param subreddit_name [String] A subreddit's display name.
      # @return [RedditKit::Subreddit]
      # @example client.subreddit "programming"
      def subreddit(subreddit_name)
        object_from_response(:get, "r/#{subreddit_name}/about.json", nil)
      end

      # Subscribes to a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's full name, or a RedditKit::Subreddit.
      def subscribe(subreddit)
        full_name = extract_full_name subreddit
        parameters = { :action => 'sub', :sr => full_name }

        post('api/subscribe', parameters)
      end

      # Unsubscribes from a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's full name, or a RedditKit::Subreddit.
      def unsubscribe(subreddit)
        full_name = extract_full_name subreddit
        parameters = { :action => 'unsub', :sr => full_name }

        post('api/subscribe', parameters)
      end

      # Gets a random subreddit.
      #
      # @return [RedditKit::Subreddit]
      def random_subreddit
        response = get('r/random', nil)
        headers = response[:response_headers]
        location = headers[:location]

        subreddit_name = location[/\/r\/(.*)\//, 1]
        subreddit subreddit_name
      end

      # Searches for subreddits with a specific name.
      #
      # @param name [String] The name to search for.
      # @return [RedditKit::PaginatedResponse]
      def search_subreddits_by_name(name)
        parameters = { :q => name }
        objects_from_response :get, 'subreddits/search.json', parameters
      end

      # Gets an array of subreddit names by topic.
      #
      # @param topic [String] The desired topic.
      # @return [Array<String>] An array of subreddit names.
      # @example RedditKit.subreddits_by_topic 'programming'
      def subreddits_by_topic(topic)
        parameters = { :query => topic }

        response = get('api/subreddits_by_topic.json', parameters)
        body =  response[:body]

        body.map { |subreddit| subreddit[:name] }
      end

      # Gets an array of recommended subreddits.
      #
      # @param subreddits [Array<String>] An array of subreddit names.
      # @return [Array<String>] An array of recommended subreddit names.
      # @example RedditKit.recommended_subreddits %w(ruby programming)
      def recommended_subreddits(subreddits)
        names = subreddits.join(',')
        parameters = { :srnames => names }

        response = get('api/subreddit_recommendations.json', parameters)
        body =  response[:body]

        body.map { |subreddit| subreddit[:sr_name] }
      end

    end
  end
end
