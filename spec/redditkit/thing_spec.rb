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
    expect(@thing == second_thing).to be true
  end

  it "is not equal to nil" do
  	expect(@thing == nil).to be false
  end
  
  it "is not equal to other types of objects" do
  	obj = Object.new
  	expect(@thing == obj).to be false
  end
end
