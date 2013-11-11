require 'spec_helper'

describe RedditKit::Client, :vcr do

  it "can retrieve default options" do
    expect(RedditKit.api_endpoint).to eq 'http://www.reddit.com/'
    expect(RedditKit.user_agent).to eq "RedditKit.rb #{RedditKit::Version}"
  end

  it "can configure options" do
    client = RedditKit::Client.new
    client.api_endpoint = "http://github.com/"

    expect(client.api_endpoint).to eq "http://github.com/"
  end

  it "should have a modhash and cookie after signing in" do
    expect(authenticated_client.modhash).to_not be_nil
    expect(authenticated_client.cookie).to_not be_nil
  end

  it "should raise an error with invalid credentials" do
    client = RedditKit::Client.new
    expect { client.sign_in "samsymons", "hunter2" }.to raise_error RedditKit::InvalidCredentials
  end

  it "should tell us whether it is signed in", :authenticated do
    client = authenticated_client

    expect(client.signed_in?).to be_true
    client.sign_out
    expect(client.signed_in?).to_not be_true
  end

  it "should be able to sign out", :authenticated do
    client = authenticated_client

    expect(client.modhash).to_not be_nil
    expect(client.cookie).to_not be_nil

    client.sign_out

    expect(client.modhash).to be_nil
    expect(client.cookie).to be_nil
  end
end
