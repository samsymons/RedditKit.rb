require 'spec_helper'

describe RedditKit::Comment, :vcr do

  # it "should return replies" do
  #   comments = RedditKit.comments '1n002d'
  #   comment = comments.first
  #
  #   expect(comment.replies?).to be true
  # end

  it "should be deleted if both author and comment attributes are set to '[deleted]'" do
    attributes = { :data => { :author => '[deleted]', :body => '[deleted]' } }
    deleted_comment = RedditKit::Comment.new attributes

    expect(deleted_comment.deleted?).to be true
  end

  it "should not be deleted if neither author and comment attributes are set to '[deleted]'" do
    comments = RedditKit.comments '1n002d'
    comment = comments.first

    expect(comment.deleted?).to be false
  end

end
