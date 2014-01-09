require 'json'
require 'redditkit/multireddit'
require 'redditkit/multireddit_description'

module RedditKit
  class Client

    # Methods for interacting with multireddits.
    module Multireddits

      # Fetch the current user's multireddits.
      #
      # @return [Array<RedditKit::Multireddit>]
      def my_multireddits
        objects_from_response(:get, 'api/multi/mine.json', nil)
      end

      # Fetch a single multireddit.
      #
      # @overload multireddit(path)
      #   @param path [String] The multireddit's path.
      # @overload multireddit(username, multireddit_name)
      #   @param username [String] The username of the user who owns the multireddit.
      #   @param multireddit_name [String] The multireddit's name.
      # @return [RedditKit::Multireddit]
      def multireddit(*args)
        path = 'api/multi'

        if args.length == 1
          path << args.first
        else
          path << path_for_multireddit(args.first, args.last << '.json')
        end

        object_from_response(:get, path, nil)
      end

      # Fetches the description for a multireddit.
      #
      # @overload multireddit_description(multireddit)
      #   @param multireddit [RedditKit::Multireddit] A RedditKit::Multireddit object.
      # @overload multireddit_description(user, multireddit_name)
      #   @param user [String, RedditKit::User] The name of the user who owns the multireddit.
      #   @param multireddit_name [String] The name of the multireddit.
      # @raise [RedditKit::NotAuthenticated] if there is not a user signed in.
      def multireddit_description(*args)
        raise RedditKit::NotAuthenticated unless signed_in?

        multireddit = args.pop
        user = args.first
        multireddit_path = nil

        if user.nil?
          multireddit_path = multireddit.path
        else
          username = extract_string(user, :username)
          multireddit_path = path_for_multireddit username, multireddit
        end

        object_from_response(:get, "api/multi#{multireddit_path}/description", nil)
      end

      # Sets the description for a multireddit.
      #
      # @param multireddit [String, RedditKit::Multireddit] The name of the multireddit, or a RedditKit::Multireddit.
      # @param description [String] The new description for the subreddit.
      # @return [RedditKit::MultiredditDescription] The updated multireddit description.
      def set_multireddit_description(multireddit, description)
        multireddit_name = extract_string(multireddit, :name)
        multireddit_path = path_for_multireddit username, multireddit_name

        model = { :body_md => description }
        parameters = { :multipath => multireddit_path, :model => model.to_json }
        path = "api/multi#{multireddit_path}/description"

        response = put path, parameters

        RedditKit::MultiredditDescription.new response[:body]
      end

      # Creates a new multireddit.
      #
      # @param multireddit [String, RedditKit::Multireddit] The name of the multireddit, or a RedditKit::Multireddit.
      # @param subreddits [Array] An array of subreddit names or RedditKit::Subreddit objects.
      # @param visibility [public, private] An array of subreddit names to be added to the multireddit.
      def create_multireddit(multireddit, subreddits = [], visibility = 'private')
        create_or_update_multireddit(:post, multireddit, subreddits, visibility)
      end

      # Updates an existing multireddit.
      #
      # @param multireddit [String, RedditKit::Multireddit] The name of the multireddit, or a RedditKit::Multireddit.
      # @param subreddits [Array] An array of subreddit names or RedditKit::Subreddit objects.
      # @param visibility [public, private] An array of subreddit names to be added to the multireddit.
      def update_multireddit(multireddit, subreddits = [], visibility = 'private')
        create_or_update_multireddit :put, multireddit, subreddits, visibility
      end

      # Copies a multireddit.
      #
      # @overload copy_multireddit(multireddit, copied_name)
      #   @param multireddit [String, RedditKit::Multireddit] The name of the multireddit, or a RedditKit::Multireddit.
      #   @param copied_name [String] The copied name for the multireddit.
      # @overload copy_multireddit(user, multireddit_name, copied_name)
      #   @param user [String, RedditKit::User] The name of the user who owns the multireddit.
      #   @param multireddit_name [String] The name of the multireddit.
      #   @param copied_name [String] The copied name for the multireddit.
      def copy_multireddit(*args)
        copied_name = args.pop
        multireddit_name = extract_string(args.pop, :name)
        user = args.first

        if user.nil?
          user = @username
        else
          user = extract_string(user, :username)
        end

        target_multireddit_path = path_for_multireddit user, multireddit_name
        destination_multireddit_path = path_for_multireddit user, copied_name
        parameters = { :from => target_multireddit_path, :to => destination_multireddit_path }

        post('api/multi/copy', parameters)
      end

      # Rename a multireddit owned by the current user.
      #
      # @param from [String] The multireddit's current name.
      # @param to [String] The new name for the multireddit.
      def rename_multireddit(from, to)
        old_multireddit_path = path_for_multireddit @username, from
        new_multireddit_path = path_for_multireddit @username, to

        parameters = { :from => old_multireddit_path, :to => new_multireddit_path }
        response = post('api/multi/rename', parameters)

        RedditKit::Multireddit.new response[:body]
      end

      # Delete a multireddit.
      #
      # @param multireddit [String, RedditKit::Multireddit] A multireddit's name, or a RedditKit::Multireddit.
      def delete_multireddit(multireddit)
        multireddit_name = extract_string(multireddit, :name)

        multireddit_path = path_for_multireddit @username, multireddit_name
        path = "api/multi#{multireddit_path}"
        parameters = { :multireddit => path_for_multireddit(@username, multireddit_name) }

        delete_path(path, parameters)
      end

      # Add a subreddit to a multireddit owned by the current user.
      #
      # @param multireddit [String, RedditKit::Multireddit] The multireddit's name, or a RedditKit::Multireddit.
      # @param subreddit [String, RedditKit::Subreddit] The subreddit's name, or a RedditKit::Subreddit.
      def add_subreddit_to_multireddit(multireddit, subreddit)
        multireddit_name = extract_string multireddit, :name
        subreddit_name = extract_string subreddit, :name

        multireddit_path = path_for_multireddit @username, multireddit_name
        path = "api/multi#{multireddit_path}/r/#{subreddit_name}"
        model = { :name => subreddit_name }

        put path, :model => model.to_json
      end

      # Removes a subreddit from a multireddit owned by the current user.
      #
      # @param multireddit [String, RedditKit::Multireddit] The multireddit's name, or a RedditKit::Multireddit.
      # @param subreddit [String, RedditKit::Subreddit] The subreddit's name, or a RedditKit::Subreddit.
      def remove_subreddit_from_multireddit(multireddit, subreddit)
        multireddit_name = extract_string multireddit, :name
        subreddit_name = extract_string subreddit, :name

        multireddit_path = path_for_multireddit @username, multireddit_name
        path = "api/multi#{multireddit_path}/r/#{subreddit_name}"

        delete_path(path, nil)
      end

      private

      # Creates or updates a multireddit.
      #
      # @param method [post, put] The HTTP method for the request. POST creates a multireddit, PUT updates one.
      # @param multireddit [String, RedditKit::Multireddit] The name of the multireddit, or a RedditKit::Multireddit.
      # @param subreddits [Array] An array of subreddit names or RedditKit::Subreddit objects.
      # @param visibility [public, private] An array of subreddit names to be added to the multireddit.
      def create_or_update_multireddit(method, multireddit, subreddits = [], visibility = 'private')
        multireddit_name = extract_string(multireddit, :name)
        multireddit_path = path_for_multireddit @username, multireddit_name
        path = "api/multi#{multireddit_path}"

        subreddit_hashes = subreddits.collect do |subreddit|
          { :name => extract_string(subreddit, :name) }
        end

        model = { :visibility => visibility, :subreddits => subreddit_hashes }
        parameters = { :multipath => multireddit_path, :model => model.to_json }

        request(method, path, parameters, connection)
      end

    end
  end
end
