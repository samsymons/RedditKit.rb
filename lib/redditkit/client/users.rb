require 'redditkit/user'

module RedditKit
  class Client

    # Methods for interacting with reddit users.
    module Users

      # Gets a user object.
      #
      # @param username [String] A reddit account's username. Gets the current user if this is nil.
      # @return [RedditKit::User]
      # @example current_user = client.user
      # @example user = client.user 'amberlynns'
      def user(username = nil)
        if username
          object_from_response(:get, "user/#{username}/about.json", nil)
        else
          object_from_response(:get, 'api/me.json', nil)
        end
      end

      # Gets links and comments for the current user.
      #
      # @option options [overview, comments, submitted, liked, disliked] :category The category from which to return links and comments. Defaults to overview.
      # @option options [1..100] :limit The number of links and comments to return.
      # @option options [String] :before Only return links and comments before this id.
      # @option options [String] :after Only return links and comments after this id.
      # @return [RedditKit::PaginatedResponse]
      def my_content(options = {})
        category = options[:category] || :overview
        path = "user/#{@username}/#{category}.json"
        options.delete :category

        objects_from_response(:get, path, options)
      end

      # Gets links and comments for a user.
      #
      # @option options [overview, comments, submitted, liked, disliked] :category The category from which to return links and comments. Defaults to overview.
      # @option options [1..100] :limit The number of links and comments to return.
      # @option options [String] :before Only return links and comments before this id.
      # @option options [String] :after Only return links and comments after this id.
      # @return [RedditKit::PaginatedResponse]
      # @note Public access to the liked and disliked categories is disabled by default, so this will return an empty array for most users.
      def user_content(user, options = {})
        username = user

        path = "user/#{username}/%s.json" % (options[:category] if options[:category])
        options.delete :category

        objects_from_response(:get, path, options)
      end

      # Gets the current user's friends.
      #
      # @return [Array<OpenStruct>]
      def friends
        response = request(:get, 'prefs/friends.json', nil, https_connection)
        body = response[:body]
        friends = body[0][:data][:children]

        friends.map { |friend| OpenStruct.new(friend) }
      end

      # Adds a user to the current user's friend list.
      #
      # @param user [String, RedditKit::User] A user's username, or a RedditKit::User.
      def friend(user)
        friend_name = extract_string(user, :username)
        friend_request 'friend', :container => current_user.full_name, :name => friend_name, :type => :friend
      end

      # Removes a user from the current user's friend list.
      #
      # @param user [String, RedditKit::User] A user's ID, or a RedditKit::User.
      def unfriend(user)
        friend_name = extract_string(user, :username)
        friend_request 'unfriend', :container => current_user.full_name, :name => friend_name, :type => :friend
      end

      # Checks whether a specific username is available.
      #
      # @param username [String] A username for which to check availability.
      # @return [Boolean]
      # @example puts "Username is available" if client.username_available? 'some_username'
      def username_available?(username)
        response = get('api/username_available.json', :user => username)
        response[:body]
      end

      # Registers a new reddit account.
      #
      # @option options [String] username The username to register.
      # @option options [String] password The password for the account.
      # @option options [String] email The optional email address for the account.
      # @option options [String] captcha_identifier The identifier for the CAPTCHA challenge solved by the user.
      # @option options [String] captcha The user's response to the CAPTCHA challenge.
      # @option options [Boolean] remember Whether to keep the user's session cookie beyond the current session.
      def register(username, password, options = {})
        parameters = { :user => username, :passwd => password, :passwd2 => password, :email => options[:email], :captcha => options[:captcha], :iden => options[:captcha_identifier] }
        post('api/register', parameters)
      end

    end
  end
end
