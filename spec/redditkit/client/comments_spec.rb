require 'spec_helper'

describe RedditKit::Client::Comments, :vcr do

  describe "#comments" do
    context "with a link identifier" do
      it "returns comments on a link" do
        comments = RedditKit.comments '1n002d'
        expect(comments).to_not be_nil
      end
    end

    context "with a RedditKit::Link" do
      it "returns comments on a link" do
        link = RedditKit.link test_link_full_name
        comments = RedditKit.comments link
        expect(comments).to_not be_nil
      end
    end
  end

  describe "#comment" do
    it "requests the correct resource" do
      comment = RedditKit.comment test_comment_full_name
      expect(comment).to_not be_nil
    end
  end

  describe "#submit_comment" do
    it "requests the correct resource" do
      comment = authenticated_client.submit_comment test_link_full_name, 'Comment submission test' 

      expect(a_post('api/comment')).to have_been_made
      expect(comment.text).to eq 'Comment submission test'

      authenticated_client.delete comment
    end
  end

end
