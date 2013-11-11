require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]
SimpleCov.start

require 'dotenv'
Dotenv.load

require 'redditkit'
require 'rspec'
require 'webmock/rspec'
require 'vcr'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

VCR.configure do |c|
  c.configure_rspec_metadata!

  c.filter_sensitive_data("<REDDIT_USERNAME>") do
    ENV['REDDITKIT_TEST_USERNAME']
  end

  c.filter_sensitive_data("<REDDIT_PASSWORD>") do
    ENV['REDDITKIT_TEST_PASSWORD']
  end

  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
end

def redditkit_username
  ENV.fetch 'REDDITKIT_TEST_USERNAME'
end

def redditkit_password
  ENV.fetch 'REDDITKIT_TEST_PASSWORD'
end

# Returns the name of a subreddit for which the test user has moderator privileges.
# Don't use an active subreddit for this, but instead one set up purely for testing.
def redditkit_subreddit
  ENV.fetch 'REDDITKIT_TEST_SUBREDDIT'
end

# Returns a full name of a link which is publicly accessible and will never be deleted.
def test_link_full_name
  't3_1n002d'
end

# Returns a link which is publicly accessible and will never be deleted.
def test_link
  authenticated_client.link test_link_full_name
end

def test_comment_full_name
  't1_cce66qf'
end

def test_comment
  authenticated_client.comment test_comment_full_name
end

def authenticated_client
  VCR.use_cassette('authenticated_client') do
    RedditKit::Client.new redditkit_username, redditkit_password
  end
end

def reddit_url(path)
  "#{RedditKit.api_endpoint}#{path}"
end

def subreddit_url(subreddit_name, path)
  "#{RedditKit.api_endpoint}r/#{subreddit_name}/#{path}"
end

def stub_empty_post_request(path)
  stub_request(:post, RedditKit.api_endpoint + path).to_return(:body => "", :headers => {:content_type => "application/json; charset=utf-8"})
end

def a_delete(path)
  a_request(:delete, RedditKit.api_endpoint + path)
end

def a_get(path)
  a_request(:get, RedditKit.api_endpoint + path)
end

def a_post(path)
  a_request(:post, RedditKit.api_endpoint + path)
end

def a_put(path)
  a_request(:put, RedditKit.api_endpoint + path)
end
