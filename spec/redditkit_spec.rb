require 'spec_helper'

describe RedditKit do

  it "returns a RedditKit::Client" do
    expect(RedditKit.client).to be_kind_of RedditKit::Client
  end

  it "caches the RedditKit::Client" do
    expect(RedditKit.client).to eq RedditKit.client
  end

  it "responds to methods on its client" do
    expect(RedditKit.respond_to?(:username)).to be_true
  end

  it "forwards methods to its client" do
    expect { RedditKit.username }.not_to raise_error
  end

end
