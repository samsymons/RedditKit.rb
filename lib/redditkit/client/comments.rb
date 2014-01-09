require 'redditkit/comment'

module RedditKit
  class Client

    # Methods for interacting with comment threads.
    module Comments

      # Get a comment object from its full name.
      #
      # @param comment_full_name [String] The full name of the comment.
      # @return [RedditKit::Comment]
      # @note This method does not include any replies to the comment.
      def comment(comment_full_name)
        comments = objects_from_response(:get, 'api/info.json', { :id => comment_full_name })
        comments.first
      end

      # Get comments on a link.
      #
      # @param link [String, RedditKit::Link] The identifier of the link, or a RedditKit::Link.
      # @option options [Integer] :limit The number of comments to return.
      # @return [Array<RedditKit::Comment>]
      def comments(link, options = {})
        return nil unless link

        link_id = extract_id link
        path = "comments/#{link_id}.json"

        comments_from_response(:get, path, options)
      end

      # Submit a comment on a link or comment.
      #
      # @param link_or_comment [String, RedditKit::Comment, RedditKit::Link] The object to comment on.
      # @param text [String] The text of the comment, formatted as Markdown.
      # @return [RedditKit::Comment] The new comment object.
      def submit_comment(link_or_comment, text)
        object_full_name = extract_full_name link_or_comment
        parameters = { :text => text, :thing_id => object_full_name, :api_type => :json }

        response = post('/api/comment', parameters)
        response_data = response[:body][:json][:data]

        full_comment_data = response_data[:things].first
        comment_data = full_comment_data[:data]
        comment_full_name = comment_data[:id]

        comment comment_full_name
      end

    end
  end
end
