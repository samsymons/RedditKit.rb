require 'ostruct'
require 'redditkit/creatable'

module RedditKit

  # A class representing a multireddit.
  class Multireddit < RedditKit::Base
    include RedditKit::Creatable

    attr_reader :name
    attr_reader :can_edit
    attr_reader :visibility
    attr_reader :path

    alias_method :editable?, :can_edit

    # An array of subreddit display names.
    #
    # @return [Array<String>]
    def subreddits
      @subreddits ||= @attributes[:subreddits].map { |subreddit| subreddit[:name] }
    end

    # The username of the multireddit's owner.
    #
    # @return [String] The owner's username.
    def username
      @username ||= path[/\/user\/(.*)\/m\//, 1]
    end

  end
end
