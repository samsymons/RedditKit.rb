require 'spec_helper'

describe RedditKit::Client::Subreddits, :vcr do

  describe "#subreddits" do
    it "returns a specified number of subreddits" do
      subreddits = RedditKit.subreddits :limit => 3
      expect(subreddits.length).to eq 3
    end

    it "returns subreddits from a specific category" do
      RedditKit.subreddits :category => 'new'
      expect(a_request(:get, "#{ RedditKit.api_endpoint }reddits/new.json")).to have_been_made
    end
  end

  describe "#subscribed_subreddits" do
    it "returns the user's subscribed subreddits" do
      subreddits = authenticated_client.subscribed_subreddits
      expect(subreddits).to_not be_empty
    end

    it "returns a specified number of subreddits" do
      subreddits = authenticated_client.subscribed_subreddits :limit => 3
      expect(subreddits.length).to eq 3
    end

    it "returns subreddits from a specific category" do
      authenticated_client.subscribed_subreddits :category => 'contributor'
      expect(a_request(:get, "#{ RedditKit.api_endpoint }subreddits/mine/contributor.json")).to have_been_made
    end
  end

  describe "#subreddit" do
    it "returns a specified subreddit" do
      subreddit = RedditKit.subreddit "programming"
      expect(subreddit.display_name).to eq "programming"
    end
  end

  describe "#subscribe" do
    it "requests the correct resource" do
      authenticated_client.subscribe "programming"
      expect(a_request(:post, "#{ RedditKit.api_endpoint }api/subscribe")).to have_been_made
    end
  end

  describe "#unsubscribe" do
    it "requests the correct resource" do
      authenticated_client.unsubscribe "programming"
      expect(a_request(:post, "#{ RedditKit.api_endpoint }api/subscribe")).to have_been_made
    end
  end

  describe "#random_subreddit" do
    it "returns a random subreddit" do
      subreddit = RedditKit.random_subreddit
      expect(subreddit).to_not be_nil
    end
  end

  describe "#search_subreddits_by_name" do
    it "returns subreddit names" do
      subreddits = RedditKit.search_subreddits_by_name 'ruby'
      expect(subreddits).to_not be_empty
    end
  end

  describe "#subreddits_by_topic" do
    it "returns subreddit names" do
      subreddits = RedditKit.subreddits_by_topic 'ruby'
      expect(subreddits).to_not be_empty
    end
  end

  describe "#recommended_subreddits" do
    it "returns subreddit names" do
      subreddits = RedditKit.recommended_subreddits %w(programming)
      expect(subreddits).to_not be_empty
    end
  end

end
