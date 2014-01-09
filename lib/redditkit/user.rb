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

    alias_method :friend?, :is_friend
    alias_method :gold?, :is_gold
    alias_method :mail?, :has_mail
    alias_method :mod?, :is_mod
    alias_method :mod_mail?, :has_mod_mail
    alias_method :over_18?, :over_18
    alias_method :username, :name
    alias_method :verified?, :has_verified_email
  end
end
