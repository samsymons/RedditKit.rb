module RedditKit
  class Client

    # Methods which don't belong in any clear categroy, such as editing and deleting items on reddit.
    module Miscellaneous

      # Edit the text or a self post or comment.
      #
      # @param object [String, RedditKit::Comment, RedditKit::Link] A link or comment's full name, a RedditKit::Link, or a RedditKit::Subreddit.
      # @option options [String] text The new text for the link or comment.
      def edit(object, options)
        parameters = { :text => options[:text], :thing_id => extract_full_name(object) }
        post('/api/editusertext', parameters)
      end

      # Deletes a link or comment.
      #
      # @param object [String, RedditKit::Comment, RedditKit::Link] A link or comment's full name, a RedditKit::Link, or a RedditKit::Subreddit.
      def delete(object)
        full_name = extract_full_name object
        post 'api/del', :id => full_name
      end

      # Saves a link or comment.
      #
      # @param object [String, RedditKit::Link, RedditKit::Subreddit] A link or comment's full name, a RedditKit::Link, or a RedditKit::Subreddit.
      def save(object)
        full_name = extract_full_name object
        post 'api/save', :id => full_name
      end

      # Unsaves a link or comment.
      #
      # @param object [String, RedditKit::Link, RedditKit::Subreddit] A link or comment's full name, a RedditKit::Link, or a RedditKit::Subreddit.
      def unsave(object)
        full_name = extract_full_name object
        post 'api/unsave', :id => full_name
      end

      # Reports a link or comment. The reddit API will also hide the link or comment.
      #
      # @param object [String, RedditKit::Link, RedditKit::Comment] A link or comment's full name, a RedditKit::Link, or a RedditKit::Subreddit.
      def report(object)
        full_name = extract_full_name object
        post 'api/report', :id => full_name
      end

    end
  end
end
