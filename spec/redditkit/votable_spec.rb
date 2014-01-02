require 'spec_helper'

describe RedditKit::Votable do

  class VotableClass
    def initialize
      @attributes = { :ups => 10, :downs => 5, :score => 5, :likes => true }
    end
  end

  before :all do
    @votable = VotableClass.new
    @votable.extend RedditKit::Votable
  end

  describe "#upvotes" do
    it "returns the number of upvotes" do
      expect(@votable.upvotes).to eq 10
    end
  end

  describe "#downvotes" do
    it "returns the number of downvotes" do
      expect(@votable.downvotes).to eq 5
    end
  end

  describe "#score" do
    it "returns the score" do
      expect(@votable.score).to eq 5
    end
  end

  describe "#upvoted?" do
    it "determines whether the object is upvoted" do
      expect(@votable.upvoted?).to be true
    end
  end

  describe "#downvoted?" do
    it "determines whether the object is downvoted" do
      expect(@votable.downvoted?).to be false
    end
  end

  describe "#voted?" do
    it "determines whether the object has been voted on" do
      expect(@votable.voted?).to be true
    end
  end

end
