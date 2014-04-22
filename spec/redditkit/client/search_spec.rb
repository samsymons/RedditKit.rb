require 'spec_helper'

describe RedditKit::Client::Search, :vcr do

  describe "#search" do
    it "returns search results" do
      results = RedditKit.search 'ruby'
      expect(results).to_not be_empty
    end

    it "restricts searches to a specific subreddit" do
      results = RedditKit.search 'ruby', :subreddit => 'ruby', :restrict_to_subreddit => true
      non_ruby_link = results.find { |link| link.subreddit != 'ruby' }

      expect(results).to_not be_empty
      expect(non_ruby_link).to be_nil
    end

    it "returns a specific number of results" do
      results = RedditKit.search 'ruby', :subreddit => 'ruby', :restrict_to_subreddit => true, :limit => 3
      expect(results.length).to eq 3
    end

    it "returns search results from the 'seen it' page" do
      results = RedditKit.search 'http://i.imgur.com/ypLqggl.png'
      expect(results).to_not be_empty
    end
  end

end
