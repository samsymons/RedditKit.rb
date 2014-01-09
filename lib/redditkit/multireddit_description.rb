require 'redditkit/base'

module RedditKit

  # A class representing a multireddit description.
  class MultiredditDescription < RedditKit::Base

    attr_reader :body_html
    attr_reader :body_md

    alias_method :text, :body_md

  end
end
