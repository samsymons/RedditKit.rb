module RedditKit

  # A class representing actions taken by moderators of subreddits.
  class ModeratorAction < RedditKit::Thing

    attr_reader :action
    attr_reader :details
    attr_reader :mod
    attr_reader :mod_id36
    attr_reader :subreddit
    attr_reader :sub_id36

    alias_method :moderator_username, :mod
    alias_method :moderator_identifier, :mod_id36
    alias_method :subreddit_name, :subreddit
    alias_method :subreddit_identifier, :sub_id36

  end
end
