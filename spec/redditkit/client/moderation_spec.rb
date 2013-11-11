require 'spec_helper'

describe RedditKit::Client::Moderation, :vcr do

  describe "#ban" do
    it "requests the correct resource" do
      authenticated_client.ban :user => 'somefakeredditusername', :subreddit => redditkit_subreddit
      expect(a_post('api/friend')).to have_been_made
    end
  end

  describe "#unban" do
    before do
      stub_empty_post_request 'api/unfriend'
    end

    it "requests the correct resource" do
      authenticated_client.unban :user => 'somefakeredditusername', :subreddit => redditkit_subreddit
      expect(a_post('api/unfriend')).to have_been_made
    end
  end

  describe "#approve" do
    before do
      stub_empty_post_request 'api/approve'
    end

    it "requests the correct resource" do
      authenticated_client.approve test_link_full_name
      expect(a_post('api/approve')).to have_been_made
    end
  end

  describe "#approve" do
    before do
      stub_empty_post_request 'api/remove'
    end

    it "requests the correct resource" do
      authenticated_client.remove test_link_full_name
      expect(a_post('api/remove')).to have_been_made
    end
  end

  describe "#ignore_reports" do
    it "requests the correct resource" do
      authenticated_client.ignore_reports test_link_full_name
      expect(a_post('api/ignore_reports')).to have_been_made
    end
  end

  describe "#unignore_reports" do
    it "requests the correct resource" do
      authenticated_client.unignore_reports test_link_full_name
      expect(a_post('api/unignore_reports')).to have_been_made
    end
  end

  describe "#distinguish" do
    before do
      stub_empty_post_request 'api/distinguish/yes'
    end

    it "requests the correct resource" do
      authenticated_client.distinguish :comment => '12345'
      expect(a_post('api/distinguish/yes')).to have_been_made
    end
  end

  describe "#set_contest_mode" do
    it "requests the correct resource" do
      authenticated_client.set_contest_mode test_link_full_name, :enabled => false
      expect(a_post('api/set_contest_mode')).to have_been_made
    end
  end

  describe "#set_sticky_post" do
    it "requests the correct resource" do
      authenticated_client.set_sticky_post test_link_full_name, :sticky => true
      expect(a_post('api/set_subreddit_sticky')).to have_been_made
    end
  end

  describe "#moderators_of_subreddit" do
    it "requests the correct resource" do
      authenticated_client.moderators_of_subreddit redditkit_subreddit
      expect(a_get("r/#{redditkit_subreddit}/about/moderators.json")).to have_been_made
    end
  end

  describe "#contributors_to_subreddit" do
    it "requests the correct resource" do
      authenticated_client.contributors_to_subreddit redditkit_subreddit
      expect(a_get("r/#{redditkit_subreddit}/about/contributors.json")).to have_been_made
    end
  end

  describe "#accept_moderator_invitation" do
    it "requests the correct resource" do
      authenticated_client.accept_moderator_invitation redditkit_subreddit
      expect(a_post('api/accept_moderator_invite')).to have_been_made
    end
  end

  describe "#resign_as_contributor" do
    before do
      stub_empty_post_request('api/leavecontributor')
    end

    it "requests the correct resource" do
      authenticated_client.resign_as_contributor '12345'
      expect(a_post('api/leavecontributor')).to have_been_made
    end
  end

  describe "#resign_as_moderator" do
    before do
      stub_empty_post_request('api/leavemoderator')
    end

    it "requests the correct resource" do
      authenticated_client.resign_as_moderator '12345'
      expect(a_post('api/leavemoderator')).to have_been_made
    end
  end

  describe "#reset_subreddit_header" do
    it "requests the correct resource" do
      authenticated_client.reset_subreddit_header redditkit_subreddit
      expect(a_post('api/delete_sr_header')).to have_been_made
    end
  end

  describe "#moderation_log" do
    it "returns RedditKit::ModeratorAction objects" do
      moderator_actions = authenticated_client.moderation_log redditkit_subreddit
      expect(moderator_actions).to_not be_nil
    end
  end

end
