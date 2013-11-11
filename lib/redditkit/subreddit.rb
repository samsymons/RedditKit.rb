require 'redditkit/thing'
require 'redditkit/creatable'

module RedditKit

  # A class representing a subreddit.
  class Subreddit < RedditKit::Thing
    include RedditKit::Creatable

    # The number of users currently active in the subreddit.
    attr_reader :accounts_active

    # The number of minutes comment scores are hidden for.
    attr_reader :comment_score_hide_mins

    # The description of the subreddit, in Markdown.
    attr_reader :description

    # The description of the subreddit, as HTML.
    attr_reader :description_html

    # The subreddit's display name. For reddit.com/r/programming, the display name is 'programming'.
    attr_reader :display_name

    # The URL to the subreddit's header image, if it has one.
    attr_reader :header_img

    # The size of the subreddit's header image, if it has one.
    attr_reader :header_size

    # The subreddit's header title.
    attr_reader :header_title

    # Whether the subreddit has been marked as having content directed at people over 18 years old.
    attr_reader :over18

    # The subreddit's public description.
    attr_reader :public_description

    # Whether the subreddit's traffic page is publicly visible.
    attr_reader :public_traffic
    attr_reader :spam_comments
    attr_reader :spam_links
    attr_reader :spam_selfpost
    attr_reader :submission_type
    attr_reader :submit_link_label
    attr_reader :submit_text
    attr_reader :submit_text_html
    attr_reader :submit_text_label

    # The subreddit's type, either 'public' or 'private'.
    attr_reader :subreddit_type

    # The number of subscribers to the subreddit.
    attr_reader :subscribers

    # The subreddit's title.
    attr_reader :title

    # The URL to the subreddit.
    attr_reader :url

    # Whether the current user is banned from the subreddit.
    attr_reader :user_is_banned

    # Whether the current user is a contributor to the subreddit.
    attr_reader :user_is_contributor

    # Whether the current user is a moderator of the subreddit.
    attr_reader :user_is_moderator

    # Whether the current user is a subscriber to the subreddit.
    attr_reader :user_is_subscriber

    alias banned? user_is_banned
    alias comment_spam_filter_strength spam_comments
    alias contributor? user_is_contributor
    alias link_spam_filter_strength spam_links
    alias moderator? user_is_moderator
    alias name display_name
    alias nsfw? over18
    alias self_post_spam_filter_strength spam_selfpost
    alias subscriber? user_is_subscriber

  end
end
