require 'spec_helper'

describe RedditKit::Client::Users, :vcr do

  describe "#user" do
    it "requests the correct resource" do
      authenticated_client.user
      expect(a_request(:get, "#{ RedditKit.api_endpoint }api/me.json")).to have_been_made
    end

    it "returns a specified user" do
      user = authenticated_client.user 'amberlynns'
      expect(user.name).to eq 'amberlynns'
    end

    it "returns the authenticated user" do
      user = authenticated_client.user
      expect(user.name).to eq redditkit_username
    end
  end

  describe "#my_content" do
    it "returns the user's content" do
      content = authenticated_client.my_content :category => :overview
      expect(content).to_not be_nil
    end
  end
  
  describe "#user_content" do
    it "returns the user's content" do
      content = RedditKit.user_content  redditkit_username, :category => :overview
      expect(content).to_not be_nil
    end
  end
  
  describe "#friends" do
    it "returns the user's friends" do
      friends = authenticated_client.friends
      expect(friends).to_not be_nil
    end
  end

  describe "#friend" do
    before do
      stub_empty_post_request 'api/friend'
    end

    it "requests the correct resource" do
      authenticated_client.friend 'username'
      expect(a_post('api/friend')).to have_been_made
    end
  end

  describe "#unfriend" do
    before do
      stub_empty_post_request 'api/unfriend'
    end

    it "requests the correct resource" do
      authenticated_client.unfriend 'username'
      expect(a_post('api/unfriend')).to have_been_made
    end
  end

  describe "#username_available?" do
    it "returns false for an unavailable username" do
      client = RedditKit::Client.new
      available = client.username_available? 'samsymons' 

      expect(available).to_not be_true
    end

    it "returns true for an available username" do
      client = RedditKit::Client.new
      available = client.username_available? 'available_user' 

      expect(available).to be_true
    end
  end

  describe "#register" do
    before do
      stub_empty_post_request 'api/register'
    end

    it "requests the correct resource" do
      RedditKit.register 'username', 'password'
      expect(a_post('api/register')).to have_been_made
    end
  end

end
