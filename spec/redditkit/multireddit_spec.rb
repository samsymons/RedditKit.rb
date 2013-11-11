require 'spec_helper'

describe RedditKit::Multireddit do

  before :all do
    subreddits = []
    subreddits << { :name => 'test1' }
    subreddits << { :name => 'test2' }
    subreddits << { :name => 'test3' }

    attributes = { :data => { :id => '12345', :path => '/user/username/m/test', :subreddits => subreddits } }
    @multireddit = RedditKit::Multireddit.new attributes
  end

  it "returns the multireddit's subreddits" do
    subreddits = @multireddit.subreddits
    result = subreddits.all? { |subreddit| subreddit.is_a? String }

    expect(subreddits.length).to eq 3
    expect(result).to be_true
  end

  it "returns the username of the multireddit's owner" do
    expect(@multireddit.username).to eq 'username'
  end

end
