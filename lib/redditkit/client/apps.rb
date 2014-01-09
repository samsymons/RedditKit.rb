module RedditKit
  class Client

    # Methods for operating on apps in the current user's account.
    module Apps

      # Create or update an app.
      #
      # @param name [String] The app's name.
      # @option options [String] description The app's description.
      # @option options [String] about_url The app's URL.
      # @option options [String] redirect_url The app's redirect URL.
      # @option options [String] app_identifier The identifier of the app, if you are updating an existing one.
      def create_app(name, options = {})
        description = options[:description]
        about_url = options[:about_url]
        redirect_url = options[:redirect_url]
        app_identifier = options[:app_identifier]
        parameters = { :client_id => app_identifier, :name => name, :description => description, :about_url => about_url, :redirect_uri => redirect_url }

        post('api/updateapp', parameters)
      end
      alias_method :update_app, :create_app

      # Delete an app.
      #
      # @param app_identifier [String] The identifier of the app.
      def delete_app(app_identifier)
        post 'api/deleteapp', :client_id => app_identifier
      end

      # Revoke an app.
      #
      # @param app_identifier [String] The identifier of the app.
      def revoke_app(app_identifier)
        post 'api/revokeapp', :client_id => app_identifier
      end

      # Add a user as a developer of an app.
      #
      # @param user [String, RedditKit::User] The username of the user to add, or a RedditKit::User.
      # @param app_identifier [String] The identifier of the app.
      def add_developer(user, app_identifier)
        username = extract_string user, :username
        parameters = { :name => username, :client_id => app_identifier }

        post 'api/adddeveloper', parameters
      end

      # Remove an app's developer.
      #
      # @param user [String, RedditKit::User] The username of the user to add, or a RedditKit::User.
      # @param app_identifier [String] The identifier of the app.
      def remove_developer(user, app_identifier)
        username = extract_string user, :username
        parameters = { :name => username, :client_id => app_identifier }

        post('api/removedeveloper', parameters)
      end

    end
  end
end
