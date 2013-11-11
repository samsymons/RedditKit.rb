require 'redditkit/thing'
require 'redditkit/creatable'

module RedditKit

  # A class representing a reddit user.
  class User < RedditKit::Thing
    include RedditKit::Creatable

    attr_reader :name
    attr_reader :comment_karma
    attr_reader :link_karma
    attr_reader :has_mail
    attr_reader :has_mod_mail
    attr_reader :has_verified_email
    attr_reader :is_gold
    attr_reader :is_friend
    attr_reader :is_mod
    attr_reader :over_18

    alias friend? is_friend
    alias gold? is_gold
    alias mail? has_mail
    alias mod? is_mod
    alias mod_mail? has_mod_mail
    alias over_18? over_18
    alias username name
    alias verified? has_verified_email
  end
end
