require 'redditkit/thing'
require 'redditkit/creatable'

module RedditKit

  # A class representing a private message.
  class PrivateMessage < RedditKit::Thing
    include RedditKit::Creatable

    attr_reader :author
    attr_reader :body
    attr_reader :body_html
    attr_reader :context
    attr_reader :dest
    attr_reader :first_message
    attr_reader :first_message_name
    attr_reader :new
    attr_reader :parent_id
    attr_reader :replies
    attr_reader :subject
    attr_reader :subreddit
    attr_reader :was_comment

    alias_method :unread?, :new
    alias_method :recipient, :dest
  end
end
