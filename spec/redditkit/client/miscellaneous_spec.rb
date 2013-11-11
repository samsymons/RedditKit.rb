require 'spec_helper'

describe RedditKit::Client::Miscellaneous, :vcr do

  describe "#edit" do
    it "requests the correct resource" do
      authenticated_client.edit 'fake-full-name', :text => 'New text'
      expect(a_post('api/editusertext')).to have_been_made
    end
  end

  describe "#delete" do
    it "requests the correct resource" do
      authenticated_client.delete 'fake-full-name'
      expect(a_post('api/del')).to have_been_made
    end
  end

  describe "#save" do
    it "saves an object" do
      authenticated_client.save test_link_full_name
      expect(a_post('api/save')).to have_been_made
    end
  end

  describe "#unsave" do
    it "unsaves an object" do
      authenticated_client.unsave test_link_full_name
      expect(a_post('api/unsave')).to have_been_made
    end
  end

  describe "#unsave" do
    it "unsaves an object" do
      authenticated_client.report 'fake-full-name'
      expect(a_post('api/report')).to have_been_made
    end
  end

end
