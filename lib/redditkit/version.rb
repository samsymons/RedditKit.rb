module RedditKit

  # A class for managing RedditKit's version number.
  class Version
    MAJOR = 2
    MINOR = 0
    PATCH = 2

    class << self
      def to_s
        [MAJOR, MINOR, PATCH].join('.')
      end
    end
  end
end
