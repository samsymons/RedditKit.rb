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
      # @option options [String] sort The sorting order for search results (relevance, new, hot, top, comments).
      # @option options [String] before Only return links before this full name. 
      # @option options [String] after Only return links after this full name.
      # @return [RedditKit::PaginatedResponse]
      def search(query, options = {})
        path = "%s/search.json" % ('r/' + options[:subreddit] if options[:subreddit])
        parameters = { :q => query, :restrict_sr => options[:restrict_to_subreddit], :limit => options[:limit], :sort => options[:sort] }
        
        objects_from_response(:get, path, parameters)
      end

    end
  end
end
