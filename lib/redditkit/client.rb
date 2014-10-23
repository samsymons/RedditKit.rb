require 'faraday'
require 'redditkit/error'
require 'redditkit/version'
require 'redditkit/client/account'
require 'redditkit/client/apps'
require 'redditkit/client/captcha'
require 'redditkit/client/comments'
require 'redditkit/client/flair'
require 'redditkit/client/links'
require 'redditkit/client/miscellaneous'
require 'redditkit/client/moderation'
require 'redditkit/client/multireddits'
require 'redditkit/client/private_messages'
require 'redditkit/client/search'
require 'redditkit/client/subreddits'
require 'redditkit/client/users'
require 'redditkit/client/utilities'
require 'redditkit/client/voting'
require 'redditkit/client/wiki'
require 'redditkit/response/parse_json'
require 'redditkit/response/raise_error'

module RedditKit

  # The client for the reddit API, handling all interactions with reddit's servers.
  class Client
    include RedditKit::Client::Account
    include RedditKit::Client::Apps
    include RedditKit::Client::Captcha
    include RedditKit::Client::Comments
    include RedditKit::Client::Flair
    include RedditKit::Client::Links
    include RedditKit::Client::Miscellaneous
    include RedditKit::Client::Moderation
    include RedditKit::Client::Multireddits
    include RedditKit::Client::PrivateMessages
    include RedditKit::Client::Search
    include RedditKit::Client::Subreddits
    include RedditKit::Client::Users
    include RedditKit::Client::Utilities
    include RedditKit::Client::Voting
    include RedditKit::Client::Wiki

    attr_reader :username
    attr_reader :current_user
    attr_reader :cookie
    attr_reader :modhash

    attr_accessor :api_endpoint
    attr_accessor :authentication_endpoint
    attr_accessor :middleware
    attr_accessor :user_agent
    attr_accessor :user_agent_name
    attr_accessor :user_agent_version

    def initialize(username = nil, password = nil, agent_name = nil, agent_version = nil)
      @username = username
      @password = password

      @user_agent_name = agent_name
      @user_agent_version = agent_version

      @cookie = nil
      @modhash = nil

      sign_in(username, password) unless username.nil? || password.nil?
    end

    def api_endpoint
      @api_endpoint ||= 'http://www.reddit.com/'
    end

    def user_agent_name
      @user_agent_name||="RedditKit.rb"
    end

    def user_agent_version
      @user_agent_version||=RedditKit::Version.to_s
    end

    def user_agent
      return @user_agent if @user_agent
      if username
        "#{user_agent_name}/#{user_agent_version} (+" << URI.join(api_endpoint,'/user/',username).to_s << ")"
      else
        "#{user_agent_name}/#{user_agent_version}"
      end
    end

    def authentication_endpoint
      @authentication_endpoint ||= 'https://ssl.reddit.com/'
    end

    def middleware
      @middleware ||= Faraday::RackBuilder.new do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use RedditKit::Response::RaiseError
        builder.use RedditKit::Response::ParseJSON
        builder.adapter Faraday.default_adapter
      end
    end

    private

    def get(path, params = nil)
      request(:get, path, params, connection)
    end

    def post(path, params = nil)
      request(:post, path, params, connection)
    end

    def https_post(path, params = nil)
      request(:post, path, params, https_connection)
    end

    def put(path, params = nil)
      request(:put, path, params, connection)
    end

    def delete_path(path, params = nil)
      request(:delete, path, params, connection)
    end

    def request(method, path, parameters = {}, request_connection)
      if signed_in?
        request = authenticated_request_configuration(method, path, parameters)
        request_connection.send(method.to_sym, path, parameters, &request).env
      else
        request_connection.send(method.to_sym, path, parameters).env
      end
    rescue Faraday::Error::ClientError
      raise RedditKit::RequestError
    end

    def authenticated_request_configuration(method, path, parameters)
      fail RedditKit::NotAuthenticated unless signed_in?

      proc do |request|
        request.headers['Cookie'] = "reddit_session=#{@cookie}"
        request.headers['X-Modhash'] = @modhash
      end
    end

    def connection
      @connection ||= connection_with_url(api_endpoint)
    end

    def https_connection
      @https_connection ||= connection_with_url(authentication_endpoint)
    end

    def connection_with_url(url)
      Faraday.new url, :builder => middleware
    end

  end
end
