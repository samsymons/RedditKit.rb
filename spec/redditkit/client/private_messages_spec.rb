require 'spec_helper'

describe RedditKit::Client::PrivateMessages, :vcr do

  describe "#messages" do
    it "requests the correct resource" do
      authenticated_client.messages
      expect(a_get('message/inbox.json')).to have_been_made
    end
  end

  describe "#send_message" do
    before do
      stub_empty_post_request 'api/compose'
    end

    it "requests the correct resource" do
      authenticated_client.send_message 'Test message', 'somefakeusername', :subject => 'Test subject'
      expect(a_post('api/compose')).to have_been_made
    end
  end

  describe "#mark_as_read" do
    it "requests the correct resource" do
      authenticated_client.mark_as_read '12345'
      expect(a_post('api/read_message')).to have_been_made
    end
  end

  describe "#mark_as_unread" do
    it "requests the correct resource" do
      authenticated_client.mark_as_unread '12345'
      expect(a_post('api/unread_message')).to have_been_made
    end
  end

  describe "#block_author_of_message" do
    it "requests the correct resource" do
      authenticated_client.block_author_of_message '12345'
      expect(a_post('api/block')).to have_been_made
    end
  end

  describe "#unblock" do
    it "requests the correct resource" do
      authenticated_client.unblock 'somefakeusername'
      expect(a_post('api/unfriend')).to have_been_made
    end
  end

end
