module RedditKit
  class Client

    # Methods for searching reddit's links.
    module Search

      # Search for links.
      #
      # @param query [String] The search query.
      # @option options [true, false] :restrict_to_subreddit Whether to search only in a specified subreddit.
      # @option options [String, RedditKit::Subreddit] :subreddit The optional subreddit to search.
      # @option options [1..100] limit The number of links to return.
<<<<<<< HEAD
      # @option options [String] sort The sorting order for search results (relevance, new, hot, top, comments).
      # @option options [String] before Only return links before this full name. 
=======
      # @option options [String, relevance, new, hot, top, comments] the order in which to return results.
      # @option options [String] before Only return links before this full name.
>>>>>>> 8d2e9880cc154914432b8db469c022157112cf2c
      # @option options [String] after Only return links after this full name.
      # @option options [String] number of results to return before or after.
      # @option options [String, all] show results from all the subreddits.
      # @option options [String, cloudsearch, lucene, plain] show results from all the subreddits.
      # @option options [String, hour, day, week, month, year, all] show results with a specific time period.
      # @return [RedditKit::PaginatedResponse]
      def search(query, options = {})
        path = "%s/search.json" % ('r/' + options[:subreddit] if options[:subreddit])
        parameters = {  :q => query,
                        :restrict_sr => options[:restrict_to_subreddit],
                        :limit       => options[:limit],
                        :sort        => options[:sort],
                        :before      => options[:before],
                        :after       => options[:after],
                        :count       => options[:count],
                        :show        => options[:show],
                        :syntax      => options[:syntax],
                        :t           => options[:t]
                      }

        objects_from_response(:get, path, parameters)
      end

    end
  end
end
