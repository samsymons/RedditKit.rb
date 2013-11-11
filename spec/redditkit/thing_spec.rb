require 'spec_helper'

describe RedditKit::Thing do

  before :all do
    @thing = RedditKit::Thing.new({ :kind => 't1', :data => { :id => '12345' } })
  end

  it "returns the thing's full name" do
    expect(@thing.full_name).to eq 't1_12345'
  end

  it "is equal to another thing with the same full name" do
    second_thing = RedditKit::Thing.new({ :kind => 't1', :data => { :id => '12345' } })
    expect(@thing == second_thing).to be_true
  end

end
