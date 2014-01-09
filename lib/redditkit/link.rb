require 'redditkit/thing'
require 'redditkit/creatable'
require 'redditkit/votable'
require 'htmlentities'

module RedditKit

  # A class representing a link.
  class Link < RedditKit::Thing
    include RedditKit::Creatable
    include RedditKit::Votable

    # The username of the moderator who approved this link, if it has been approved.
    attr_reader :approved_by

    # The username of the link's author.
    attr_reader :author

    # The author's flair CSS class, if they have flair assigned to them.
    attr_reader :author_flair_css_class

    # The author's flair text, if they have flair assigned to them.
    attr_reader :author_flair_text

    # The username of the moderator who banned this link, if it was banned.
    attr_reader :banned_by

    # The distinguished status of the link. This is either 'yes', 'no', 'admin' or 'special'.
    attr_reader :distinguished

    # The link's domain.
    attr_reader :domain

    # The time of the link's most recent edit, or nil if it has never been edited.
    attr_reader :edited

    # Whether the current user has hidden this link.
    attr_reader :hidden

    # Whether the link is a self post.
    attr_reader :is_self

    # The link's flair CSS class, if it has flair assigned to it.
    attr_reader :link_flair_css_class

    # The link's flair text, if it has flair assigned to it.
    attr_reader :link_flair_text

    # A hash containing further information about the link's media. For example, this could contain details about a YouTube video.
    attr_reader :media

    # A hash contains details for embedding the content in a web page.
    attr_reader :media_embed

    # The number of comments on the link.
    attr_reader :num_comments

    # The number of reports on the link.
    attr_reader :num_reports

    # Whether the link has been marked as NSFW.
    attr_reader :over_18

    # The link to the post on reddit.
    attr_reader :permalink

    # Whether the current user has saved this link.
    attr_reader :saved

    # The text for the link, if it is a self post, in Markdown.
    attr_reader :selftext

    # The text for the link, if it is a self post, in HTML.
    attr_reader :selftext_html

    # Whether the link has been marked as sticky.
    attr_reader :stickied

    # The name of the subreddit to which the link was posted.
    attr_reader :subreddit

    # The full name of the subreddit to which the link was posted.
    attr_reader :subreddit_id

    # The URL to the thumbnail for the link.
    attr_reader :thumbnail

    # The title of the link.
    attr_reader :title

    # The link's URL. This will be a link to the post on reddit if the link is a self post.
    attr_reader :url

    # Whether the link has been visited by the current user. Requires that the current user have reddit gold.
    attr_reader :visited

    alias_method :approved?, :approved_by
    alias_method :banned?, :banned_by
    alias_method :nsfw?, :over_18
    alias_method :self_post?, :is_self
    alias_method :sticky?, :stickied
    alias_method :subreddit_full_name, :subreddit_id
    alias_method :text, :selftext
    alias_method :text_html, :selftext_html
    alias_method :thumbnail_url, :thumbnail
    alias_method :total_comments, :num_comments
    alias_method :total_reports, :num_reports

    def title
      @escaped_title ||= HTMLEntities.new.decode(@attributes[:title])
    end

    # The link's URL. This will be a link to the post on reddit if the link is a self post.
    #
    # @note This is HTML decoded as reddit encodes their JSON, meaning links which have parameters will be returned incorrectly.
    def url
      @escaped_url ||= HTMLEntities.new.decode(@attributes[:url])
    end

    # Determines whether a link is showing its score. reddit doesn't display scores for links less than two hours old.
    #
    # @return [Boolean]
    def showing_link_score?
      current_time = Time.now
      submission_time = created_at

      difference = (current_time - submission_time) / 60 / 60
      difference >= 2
    end

    # Determines whether a link has an image URL.
    #
    # @return [Boolean]
    def image_link?
      extensions = %w(.png .jpg .jpeg .gif)
      extensions.any? { |extension| url.end_with? extension }
    end

    def permalink
      @permalink ||= 'http://reddit.com/' << @attributes[:permalink]
    end

    # Returns the short URL for a link.
    #
    # @return [String]
    # @example http://redd.it/link-id.
    def short_link
      'http://redd.it/' << id
    end

  end
end
