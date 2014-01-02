require 'spec_helper'

describe RedditKit::Client::Links, :vcr do

  describe "#front_page" do
    it "requests the correct resource" do
      RedditKit.front_page
      expect(a_get('hot.json')).to have_been_made
    end

    it "requests the correct category" do
      RedditKit.front_page :category => :rising
      expect(a_get('rising.json')).to have_been_made
    end
  end

  describe "#links" do
    it "requests front page links if no subreddit is present" do
      RedditKit.links nil
      expect(a_get('hot.json')).to have_been_made
    end

    it "requests the correct subreddit and category" do
      RedditKit.links 'programming', :category => :hot
      expect(a_get('r/programming/hot.json')).to have_been_made
    end

    it "requests links with the correct time frame" do
      RedditKit.links 'programming', :category => :top, :time => :year
      expect(a_get('r/programming/top.json?t=year')).to have_been_made
    end

    it "requests a certain number of links" do
      links = RedditKit.links 'programming', :limit => 10
      expect(links.length).to eq 10
    end

    it "contains pagination information" do
      links = RedditKit.links 'programming'

      expect(links.after).to_not be_nil
      expect(links.results).to_not be_empty
    end
  end

  describe "#link" do
    it "returns a link" do
      link = RedditKit.link "t3_1n002d"
      expect(link).to_not be_nil
    end
  end

  describe "#links_with_domain" do
    it "returns links with a specific domain" do
      links = RedditKit.links_with_domain "github.com"
      result = links.all? { |link| link.domain == 'github.com' }

      expect(result).to be true
    end
  end

  describe "#submit" do
    it "raises RedditKit::InvalidCaptcha if no CAPTCHA is filled out" do
      expect { authenticated_client.submit 'Test', redditkit_subreddit, :text => 'Test post' }.to raise_error RedditKit::InvalidCaptcha
    end
  end

  describe "#mark_nsfw" do
    it "requests the correct resource" do
      authenticated_client.mark_nsfw test_link_full_name
      expect(a_post('api/marknsfw')).to have_been_made
    end
  end

  describe "#unmark_nsfw" do
    it "requests the correct resource" do
      authenticated_client.unmark_nsfw test_link_full_name
      expect(a_post('api/unmarknsfw')).to have_been_made
    end
  end

  describe "#hide" do
    it "requests the correct resource" do
      authenticated_client.hide test_link_full_name
      expect(a_post('api/hide')).to have_been_made
    end
  end

  describe "#unhide" do
    it "requests the correct resource" do
      authenticated_client.unhide test_link_full_name
      expect(a_post('api/unhide')).to have_been_made
    end
  end

  describe "#random_link" do
    it "returns a random link" do
      link = RedditKit.random_link
      expect(link).to_not be_nil
    end
  end

end
