module RedditKit
  class Client

    # Methods for searching reddit's links.
    module Search

      # Search for links.
      #
      # @param query [String] The search query.
      # @option options [String, RedditKit::Subreddit] subreddit The optional subreddit to search.
      # @option options [true, false] restrict_to_subreddit Whether to search only in a specified subreddit.
      # @option options [1..100] limit The number of links to return.
      # @option options [String] count The number of results to return before or after. This is different from `limit`.
      # @option options [relevance, new, hot, top, comments] sort The sorting order for search results.
      # @option options [String] before Only return links before this full name.
      # @option options [String] after Only return links after this full name.
      # @option options [cloudsearch, lucene, plain] syntax Specify the syntax for the search. Learn more: http://www.reddit.com/r/redditdev/comments/1hpicu/whats_this_syntaxcloudsearch_do/cawm0fe
      # @option options [hour, day, week, month, year, all] time Show results with a specific time period.
      # @return [RedditKit::PaginatedResponse]
      def search(query, options = {})
        path = "%s/search.json" % ('r/' + options[:subreddit] if options[:subreddit])
        parameters = { :q => query,
                       :restrict_sr => options[:restrict_to_subreddit],
                       :limit       => options[:limit],
                       :count       => options[:count],
                       :sort        => options[:sort],
                       :before      => options[:before],
                       :after       => options[:after],
                       :syntax      => options[:syntax],
                       :t           => options[:time]
        }

        objects_from_response(:get, path, parameters)
      end

    end
  end
end
