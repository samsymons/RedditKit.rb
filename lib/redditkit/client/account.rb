module RedditKit
  class Client

    # Methods which operate on a user's account.
    module Account

      # Sign in to a reddit account.
      #
      # @see http://www.reddit.com/dev/api#POST_api_login
      # @param username [String] The reddit account's username.
      # @param password [String] The reddit account's password.
      def sign_in(username, password)
        response = https_post 'api/login', { :user => username, :passwd => password, :api_type => :json }
        body = response[:body]

        data = body[:json][:data]

        @modhash = data[:modhash]
        @cookie = data[:cookie]
        @username = username

        @current_user = user @username
        @username = @current_user.username
      end

      # Check is a user is currently signed in.
      #
      # @return [Boolean]
      def signed_in?
        !!@modhash and !!@cookie
      end

      # Sign the current user out.
      def sign_out
        @username = nil
        @current_user = nil

        @modhash = nil
        @cookie = nil
      end

      # Updates the current user's email or password.
      #
      # @see http://www.reddit.com/dev/api#POST_api_update
      # @option options [String] current_password The user's current password.
      # @option options [String] new_password The user's new password.
      # @option options [String] email The user's new email address.
      def update_account(options)
        password = options[:new_password]
        parameters = { :curpass => options[:current_password], :email => options[:email], :newpass => password, :verpass => password, :api_type => :json }

        post('api/update', parameters)
      end

      # Invalidates all session cookies and updates the current one.
      #
      # @see http://www.reddit.com/dev/api#POST_api_clear_sessions
      # @param password [String] The authenticated user's current password.
      # @return [String] The new cookie value.
      def update_session(password)
        response = post('api/clear_sessions', :dest => api_endpoint, :curpass => password, :api_type => 'json')

        response_headers = response[:response_headers]
        full_cookie_string = response_headers['set-cookie']
        cookie = full_cookie_string[/reddit_session=(.*?);/m, 1]

        @cookie = cookie
        cookie
      end

    end
  end
end
