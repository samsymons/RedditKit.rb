require 'spec_helper'

describe RedditKit::Client::Wiki, :vcr do

  describe "#add_wiki_editor" do
    it "requests the correct resource" do
      authenticated_client.add_wiki_editor :user => 'samsymons', :subreddit => redditkit_subreddit
      expect(a_post("r/#{redditkit_subreddit}/api/wiki/alloweditor/add")).to have_been_made
    end
  end

  describe "#remove_wiki_editor" do
    it "requests the correct resource" do
      authenticated_client.remove_wiki_editor :user => 'samsymons', :subreddit => redditkit_subreddit
      expect(a_post("r/#{redditkit_subreddit}/api/wiki/alloweditor/del")).to have_been_made
    end
  end

  describe "#edit_wiki_page" do
    it "requests the correct resource" do
      authenticated_client.edit_wiki_page :subreddit => redditkit_subreddit, :page => 'fake-page', :revision => '12345'
      expect(a_post("r/#{redditkit_subreddit}/api/wiki/edit")).to have_been_made
    end
  end

  describe "#hide_wiki_revision" do
    it "requests the correct resource" do
      authenticated_client.hide_wiki_revision :subreddit => redditkit_subreddit, :page => 'fake-page', :revision => '12345'
      expect(a_post("r/#{redditkit_subreddit}/api/wiki/hide")).to have_been_made
    end
  end

  describe "#revert_to_revision" do
    it "requests the correct resource" do
      authenticated_client.revert_to_revision :subreddit => redditkit_subreddit, :page => 'fake-page', :revision => '12345'
      expect(a_post("r/#{redditkit_subreddit}/api/wiki/revert")).to have_been_made
    end
  end

end
