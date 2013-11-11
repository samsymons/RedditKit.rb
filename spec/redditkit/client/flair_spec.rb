require 'spec_helper'

describe RedditKit::Client::Flair, :vcr do

  describe "#flair_list" do
    it "returns the list of flair" do
      authenticated_client.flair_list redditkit_subreddit
      
      path = subreddit_url redditkit_subreddit, 'api/flairlist.json'
      expect(a_request(:get, path)).to have_been_made
    end
  end
  
  describe "#create_flair_template" do
    it "creates a flair template" do
      authenticated_client.create_flair_template redditkit_subreddit, :user, :text => 'Test', :css_class => 'some-class', :user_editable => false
      expect(a_post('api/flairtemplate')).to have_been_made
    end

    it "raises InvalidClassName" do
      options = { :text => 'Invalid', :css_class => 'some_class!', :user_editable => false }
      expect { authenticated_client.create_flair_template(redditkit_subreddit, :user, options) }.to raise_error RedditKit::InvalidClassName
    end

    it "raises TooManyClassNames" do
      options = { :text => 'Invalid', :css_class => 'one two three four five six seven eight nine ten eleven', :user_editable => false }
      expect { authenticated_client.create_flair_template(redditkit_subreddit, :user, options) }.to raise_error RedditKit::TooManyClassNames
    end
  end

  describe "#delete_flair_template" do
    before do
      stub_empty_post_request 'api/deleteflairtemplate'
    end

    it "deletes a flair template" do
      authenticated_client.delete_flair_template redditkit_subreddit, '12345'
      expect(a_post('api/deleteflairtemplate')).to have_been_made
    end
  end

  describe "#toggle_flair" do
    it "requests the correct resource" do
      authenticated_client.toggle_flair redditkit_subreddit, true
      expect(a_post('api/setflairenabled')).to have_been_made
    end
  end

  describe "#set_flair" do
    it "requests the correct resource" do
      authenticated_client.set_flair :subreddit => 'RedditKitTesting', :text => 'Test flair', :css_class => 'testclass', :link => test_link_full_name
      expect(a_post('api/flair')).to have_been_made
    end
  end

  describe "#set_flair_with_csv" do
    it "requests the correct resource" do
      authenticated_client.set_flair_with_csv redditkit_subreddit, 'samsymons,Test CSV,csvclass'
      expect(a_post('api/flaircsv')).to have_been_made
    end
  end

  describe "#delete_user_flair" do
    it "requests the correct resource" do
      authenticated_client.delete_user_flair redditkit_subreddit, 'samsymons'
    end
  end

  describe "#clear_flair_templates" do
    it "clears flair templates" do
      authenticated_client.clear_flair_templates :subreddit => redditkit_subreddit, :type => :user
      expect(a_request(:post, reddit_url('api/clearflairtemplates'))).to have_been_made 
    end
  end

  describe "#apply_flair_template" do
    it "clears flair templates" do
      authenticated_client.apply_flair_template :subreddit => redditkit_subreddit, :template_id => '12345', :link => test_link_full_name
      expect(a_request(:post, reddit_url('api/selectflair'))).to have_been_made 
    end
  end

  describe "#set_flair_options" do
    it "sets flair options" do
      parameters = { flair_enabled: 'true', flair_position: 'right', link_flair_position: 'right', flair_self_assign_enabled: 'true', link_flair_self_assign_enabled: 'true' }
      authenticated_client.set_flair_options redditkit_subreddit, parameters

      expect(a_request(:post, reddit_url('api/flairconfig'))).to have_been_made
    end
  end

end
