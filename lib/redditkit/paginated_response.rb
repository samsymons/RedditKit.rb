require 'forwardable'

module RedditKit

  # A response object for paginated requests, allowing users to access both results and pagination data.
  class PaginatedResponse
    extend Forwardable
    include Enumerable
    def_delegators :@results, :each, :length, :empty?

    attr_reader :results
    attr_reader :before
    attr_reader :after

    def initialize(before, after, results)
      @before = before
      @after = after
      @results = results
    end

  end
end
