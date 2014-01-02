require 'spec_helper'

describe RedditKit::Client::Voting do
  
  describe "#upvote", :vcr do
    context "with a comment full name passed" do
      it "upvotes the comment" do
        authenticated_client.upvote test_comment_full_name
        expect(test_comment.upvoted?).to be true
      end
    end
    
    context "with a link full name passed" do
      it "upvotes the link" do
        authenticated_client.upvote test_link_full_name
        expect(test_link.upvoted?).to be true
      end
    end

    context "with a comment passed" do
      it "upvotes the comment" do
        authenticated_client.upvote test_comment
        expect(test_comment.upvoted?).to be true
      end
    end

    context "with a link passed" do
      it "upvotes the link" do
        authenticated_client.upvote test_link
        expect(test_link.upvoted?).to be true
      end
    end
  end

  describe "#downvote", :vcr do
    context "with a comment full name passed" do
      it "downvotes the comment" do
        authenticated_client.downvote test_comment_full_name
        expect(test_comment.downvoted?).to be true
      end
    end
    
    context "with a link full name passed" do
      it "downvotes the link" do
        authenticated_client.downvote test_link_full_name
        expect(test_link.downvoted?).to be true
      end
    end

    context "with a comment passed" do
      it "downvotes the comment" do
        authenticated_client.downvote test_comment
        expect(test_comment.downvoted?).to be true
      end
    end

    context "with a link passed" do
      it "downvotes the link" do
        authenticated_client.downvote test_link
        expect(test_link.downvoted?).to be true
      end
    end
  end

  describe "#withdraw_vote", :vcr do
    context "with a comment full name passed" do
      it "withdraws the vote on the comment" do
        authenticated_client.withdraw_vote test_comment_full_name
        expect(test_comment.upvoted?).to be false
        expect(test_comment.downvoted?).to be false
      end
    end
    
    context "with a link full name passed" do
      it "withdraws the vote on the link" do
        authenticated_client.withdraw_vote test_link_full_name
        expect(test_link.upvoted?).to be false
        expect(test_link.downvoted?).to be false
      end
    end

    context "with a comment passed" do
      it "withdraws the vote on the comment" do
        authenticated_client.withdraw_vote test_comment
        expect(test_comment.upvoted?).to be false
        expect(test_comment.downvoted?).to be false
      end
    end

    context "with a link passed" do
      it "withdraws the vote on the link" do
        authenticated_client.withdraw_vote test_link
        expect(test_link.upvoted?).to be false
        expect(test_link.downvoted?).to be false
      end
    end
  end

end
