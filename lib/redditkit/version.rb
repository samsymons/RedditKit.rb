module RedditKit

  # A class for managing RedditKit's version number.
  class Version
    MAJOR = 1
    MINOR = 1
    PATCH = 0

    class << self
      def to_s
        [MAJOR, MINOR, PATCH].join('.')
      end
    end
  end
end
