require 'time'

module RedditKit

  # Methods which return the time of creation for objects.
  module Creatable

    # The time when the object was created on reddit.
    #
    # @return [Time]
    def created_at
      created = @attributes[:created_utc]
      @created_at ||= Time.at(created) if created
    end

  end
end
