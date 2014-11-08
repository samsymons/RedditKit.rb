# encoding: utf-8

require 'spec_helper'

describe RedditKit::Link do
  before :all do
    attributes = { :data => { :id => '12345', :title => "&amp;", :url => 'http://example.com/test.png', :permalink => 'permalink', :created_utc => Time.now.to_i } }
    @link = RedditKit::Link.new attributes

    old_link_attributes = { :data => { :id => '12345', :url => 'http://example.com/test.png', :created_utc => Time.new(2000, 1, 1).to_i } }
    @old_link = RedditKit::Link.new old_link_attributes

    parameter_link_attributes = { :data => { :id => '12345', :url => 'http://example.com/test?param=something&amp;whatever=test', :created_utc => Time.new(2000, 1, 1).to_i } }
    @link_with_parameters = RedditKit::Link.new parameter_link_attributes

    unicode_link_attributes = { :data => { :id => '12345', :permalink => '이것은_웹_페이지입니', :created_utc => Time.new(2000, 1, 1).to_i } }
    @link_with_unicode = RedditKit::Link.new unicode_link_attributes
  end

  it "decodes HTML entities in link titles" do
    expect(@link.title).to eq '&'
  end

  it "decodes HTML entities in link URLs" do
    expect(@link_with_parameters.url).to eq 'http://example.com/test?param=something&whatever=test'
  end

  it "does not show the score for new links" do
    expect(@link.showing_link_score?).to be false
  end

  it "shows the score for old links" do
    expect(@old_link.showing_link_score?).to be true
  end

  describe 'image_link?' do
    it 'returns true if the link has an image extension' do
      attributes = { :data => { :id => '12345', :url => 'http://example.com/test.png' } }
      link = RedditKit::Link.new attributes

      expect(link.image_link?).to be_truthy
    end

    it 'returns false if the link does not have an image extension' do
      attributes = { :data => { :id => '12345', :url => 'http://example.com/' } }
      link = RedditKit::Link.new attributes

      expect(link.image_link?).to be_falsy
    end
  end

  describe 'permalink' do
    it "returns the link's permalink" do
      attributes = { :data => { :id => '12345', :title => 'Permalink', :url => 'http://example.com/test.png', :permalink => 'permalink', :created_utc => Time.now.to_i } }
      link = RedditKit::Link.new attributes

      expect(link.permalink).to eq 'http://www.reddit.com/permalink'
    end

    it 'does not allow duplicate forward slashes' do
      attributes = { :data => { :id => '12345', :title => 'Permalink', :url => 'http://example.com/test.png', :permalink => '/r/technology/comments/2lndtl/pirate_bay_is_still_online_even_though_all_of_its/', :created_utc => Time.now.to_i } }
      link = RedditKit::Link.new attributes

      expect(link.permalink).to eq 'http://www.reddit.com/r/technology/comments/2lndtl/pirate_bay_is_still_online_even_though_all_of_its/'
    end

    it "returns the link's encoded permalink" do
      expect(@link_with_unicode.permalink).to eq 'http://www.reddit.com/%EC%9D%B4%EA%B2%83%EC%9D%80_%EC%9B%B9_%ED%8E%98%EC%9D%B4%EC%A7%80%EC%9E%85%EB%8B%88'
    end
  end

  it "returns the link's short URL" do
    expect(@link.short_link).to eq 'http://redd.it/12345'
  end
end
