module RedditKit

  # A class for managing RedditKit's version number.
  class Version
    MAJOR = 1
    MINOR = 0
    PATCH = 6

    class << self

      # Return RedditKit.rb's version number as a string.
      def to_s
        [MAJOR, MINOR, PATCH].join('.')
      end

    end

  end
end
