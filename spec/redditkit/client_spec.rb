require 'spec_helper'

describe RedditKit::Client, :vcr do

  it "can retrieve default options" do
    expect(RedditKit.api_endpoint).to eq 'http://www.reddit.com/'
    expect(RedditKit.user_agent).to eq "RedditKit.rb/#{RedditKit::Version}"
  end

  it "can configure options" do
    client = RedditKit::Client.new
    client.api_endpoint = "http://github.com/"

    expect(client.api_endpoint).to eq "http://github.com/"
  end

  it "can configure an agent string" do
    client = RedditKit::Client.new nil,nil,"TestAgentBot","86"

    expect(client.user_agent).to eq "TestAgentBot/86"


    client.user_agent_name = "OtherTestAgentBot"
    client.user_agent_version = 99
    expect(client.user_agent).to eq "OtherTestAgentBot/99"

    client.user_agent = "ThirdTestAgentBot/7.00 (+http://www.reddit.com/user/user/samsymons)"
    expect(client.user_agent).to eq "ThirdTestAgentBot/7.00 (+http://www.reddit.com/user/user/samsymons)"

    client.user_agent = nil
    expect(client.user_agent).to eq "OtherTestAgentBot/99"

    client = RedditKit::Client.new "samsymons",nil,"FourthTestAgentBot","86"
    expect(client.user_agent).to eq "FourthTestAgentBot/86 (+http://www.reddit.com/user/samsymons)"
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

    expect(client.signed_in?).to be true
    client.sign_out
    expect(client.signed_in?).to be false
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