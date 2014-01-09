module RedditKit
  class Client

    # Methods for voting on links and comments.
    module Voting

      # Upvotes a link or comment.
      #
      # @param link_or_comment [String, RedditKit::Comment, RedditKit::Link] The link or comment to upvote.
      def upvote(link_or_comment)
        vote link_or_comment, 1
      end

      # Downvotes a link or comment.
      #
      # @param link_or_comment [String, RedditKit::Comment, RedditKit::Link] The link or comment to downvote.
      def downvote(link_or_comment)
        vote link_or_comment, -1
      end

      # Withdraws a vote on a link or comment.
      #
      # @param link_or_comment [String, RedditKit::Comment, RedditKit::Link] The link or comment from which to withdraw the vote.
      def withdraw_vote(link_or_comment)
        vote link_or_comment, 0
      end

      # Votes on a link or comment.
      #
      # @param link_or_comment [String, RedditKit::Comment, RedditKit::Link] The link or comment from which to withdraw the vote.
      # @param direction [-1, 0, 1] Downvote, no vote, and upvote respectively.
      def vote(link_or_comment, direction)
        full_name = extract_full_name(link_or_comment)
        parameters = { :id => full_name, :dir => direction, :api_type => 'json' }

        post('api/vote', parameters)
      end

    end
  end
end
