module RedditKit

  # Methods which determine the voting status of objects.
  module Votable

    # The number of upvotes an item has.
    def upvotes
      @attributes[:ups]
    end

    # The number of downvotes an item has.
    def downvotes
      @attributes[:downs]
    end

    # The score for an item.
    def score
      @attributes[:score]
    end

    # Whether the current user has upvoted this item.
    def upvoted?
      @attributes[:likes] == true
    end

    # Whether the current user has downvotes this item.
    def downvoted?
      @attributes[:likes] == false
    end

    # Whether the user has voted on this item (either upvoted or downvoted).
    def voted?
      !@attributes[:likes].nil?
    end

  end
end
