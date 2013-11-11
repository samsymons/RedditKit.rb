require 'spec_helper'

describe RedditKit::Client::Captcha, :vcr do

  describe "#needs_captcha?" do
    it "checks if the current account needs a CAPTCHA" do
      authenticated_client.needs_captcha?
      expect(a_get('api/needs_captcha.json')).to have_been_made
    end
  end

  describe "#new_captcha_identifier" do
    it "returns a new CAPTCHA identifier" do
      identifier = RedditKit.new_captcha_identifier

      expect(a_post('api/new_captcha')).to have_been_made
      expect(identifier).to be_kind_of String
    end
  end

  describe "#captcha_url" do
    it "returns a CAPTCHA url from an identifier" do
      identifier = RedditKit.new_captcha_identifier
      captcha_url = RedditKit.captcha_url identifier

      expect(captcha_url).to eq "http://reddit.com/captcha/#{identifier}.png"
    end
  end

end
