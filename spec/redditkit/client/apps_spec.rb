require 'spec_helper'

describe RedditKit::Client::Apps, :vcr do

  describe "#create_app" do
    before do
      stub_empty_post_request('api/updateapp')
    end

    it "requests the correct resource" do
      authenticated_client.create_app 'Test app', :description => 'Some test app'
      expect(a_post('api/updateapp')).to have_been_made
    end
  end

  describe "#delete_app" do
    before do
      stub_empty_post_request('api/deleteapp')
    end

    it "requests the correct resource" do
      authenticated_client.delete_app 'fake-identifier'
      expect(a_post('api/deleteapp')).to have_been_made
    end
  end

  describe "#revoke_app" do
    before do
      stub_empty_post_request('api/revokeapp')
    end
    it "requests the correct resource" do
      authenticated_client.revoke_app 'fake-identifier'
      expect(a_post('api/revokeapp')).to have_been_made
    end
  end

  describe "#add_developer" do
    before do
      stub_empty_post_request('api/adddeveloper')
    end
    it "requests the correct resource" do
      authenticated_client.add_developer 'fake-user', 'fake-identifier'
      expect(a_post('api/adddeveloper')).to have_been_made
    end
  end
  
  describe "#remove_developer" do
    before do
      stub_empty_post_request('api/removedeveloper')
    end

    it "requests the correct resource" do
      authenticated_client.remove_developer 'fake-user', 'fake-identifier'
      expect(a_post('api/removedeveloper')).to have_been_made
    end
  end

end
