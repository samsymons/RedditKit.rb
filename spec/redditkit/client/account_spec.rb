require 'spec_helper'

describe RedditKit::Client::Account, :vcr do

  describe "#sign_in" do
    it "signs the user in" do
      client = RedditKit::Client.new redditkit_username, redditkit_password

      expect(client.signed_in?).to be_true
      expect(client.user).to_not be_nil
    end
  end

  describe "#signed_in?" do
    it "determines whether there is a user signed in" do
      expect(authenticated_client.signed_in?).to be_true
    end
  end

  describe "#sign_out" do
    it "signs the current user out" do
      client = RedditKit::Client.new :username => redditkit_username, :password => redditkit_password
      client.sign_out

      expect(client.signed_in?).to_not be_true
    end
  end

  describe "#update_account" do
    before do
      stub_empty_post_request 'api/update'
    end

    it "requests the correct resource" do
      authenticated_client.update_account :current_password => redditkit_password, :new_password => redditkit_password
      expect(a_post('api/update')).to have_been_made
    end
  end

  describe "#update_session" do
    it "updates the current session" do
      client = RedditKit::Client.new redditkit_username, redditkit_password
      old_cookie = client.cookie

      new_cookie = client.update_session redditkit_password
      expect(old_cookie).to_not eq new_cookie
    end
  end

end
