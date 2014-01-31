require 'redditkit/base'

module RedditKit

  # A base class for objects which have both a kind and an identifier.
  class Thing < RedditKit::Base

    attr_reader :id
    attr_reader :kind

    def ==(other)
      return false unless other.is_a?(Thing)
      full_name == other.full_name
    end

    # Returns the object's full name.
    def full_name
      @full_name ||= "#{kind}_#{id}"
    end
  end
end
