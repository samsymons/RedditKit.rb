require 'spec_helper'

describe RedditKit::User do

  before :all do
    attributes = { :data => { :id => '12345', :name => "samsymons", :is_friend => false, :created => 1396889270, :created_utc => 1396889270, :link_karma => 0, :comment_karma => 0, :is_gold => true, :is_mod => true, :has_verified_email => true } }
    @user = RedditKit::User.new attributes
  end

  it "returns the user's URI" do
    expect(@user.uri.to_s).to eq 'http://www.reddit.com/user/samsymons'
  end

end
