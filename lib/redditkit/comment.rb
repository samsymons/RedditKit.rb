require 'redditkit/thing'
require 'redditkit/creatable'
require 'redditkit/votable'

module RedditKit

  # A class representing a comment.
  class Comment < RedditKit::Thing
    include RedditKit::Creatable
    include RedditKit::Votable

    attr_reader :approved_by
    attr_reader :author
    attr_reader :author_flair_css_class
    attr_reader :author_flair_text
    attr_reader :author_id
    attr_reader :banned_by
    attr_reader :body
    attr_reader :body_html
    attr_reader :distinguished
    attr_reader :edited
    attr_reader :gilded
    attr_reader :link_id
    attr_reader :num_reports
    attr_reader :score_hidden
    attr_reader :subreddit
    attr_reader :subreddit_id

    alias_method :text, :body
    alias_method :posted_at, :created_at

    # Whether a comment has been deleted by its submitter or a moderator.
    def deleted?
      author == '[deleted]' and body == '[deleted]'
    end

    # The replies to a comment.
    def replies
      replies_listing = @attributes[:replies]
      return [] if replies_listing.empty?

      replies_array = replies_listing[:data][:children]

      @comment_objects ||= replies_array.map do |comment|
        RedditKit::Comment.new(comment)
      end
    end

    # Whether the comment has any replies.
    def replies?
      !replies.empty?
    end
  end
end
