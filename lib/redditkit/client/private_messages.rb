require 'redditkit/private_message'

module RedditKit
  class Client

    # Methods for retrieving and sending private messages.
    module PrivateMessages

      # Gets the current user's private messages or comment replies.
      #
      # @option options [inbox, unread, sent, messages, mentions, moderator, comments, selfreply] :category The category from which to return messages.
      # @option options [1..100] :limit The number of messages to return.
      # @option options [String] :before Only return subreddits before this id.
      # @option options [String] :after Only return subreddits after this id.
      # @option options [Boolean] :mark Whether to mark requested messages as read.
      # @return [RedditKit::PaginatedResponse]
      def messages(options = {})
        category = options[:category] || 'inbox'
        path = "message/#{category}.json"
        options.delete :category

        objects_from_response(:get, path, options)
      end

      # Send a message to another reddit user.
      #
      # @param message [String] The text of the message.
      # @param recipient [String, RedditKit::User] The recipient of the message.
      # @option options [String] :subject The subject of the message.
      # @option options [String] :captcha_identifier A CAPTCHA identifier to send with the message, if the current user is required to fill one out.
      # @option options [String] :captcha_value The value of the CAPTCHA to send with the message, if the current user is required to fill one out.
      def send_message(message, recipient, options = {})
        username = extract_string(recipient, :username)
        parameters = { :to => username, :text => message, :subject => options[:subject], :captcha => options[:captcha_value], :iden => options[:captcha_identifier] }

        post('api/compose', parameters)
      end

      # Marks a message as read.
      #
      # @param message [String, RedditKit::PrivateMessage] A private message's full name, or a RedditKit::PrivateMessage.
      def mark_as_read(message)
        parameters = { :id => extract_full_name(message) }
        post('api/read_message', parameters)
      end

      # Marks a message as unread.
      #
      # @param message [String, RedditKit::PrivateMessage] A private message's full name, or a RedditKit::PrivateMessage.
      def mark_as_unread(message)
        parameters = { :id => extract_full_name(message) }
        post('api/unread_message', parameters)
      end

      # Blocks the author of a private message or comment.
      # Users cannot be blocked based on username as reddit only allows you to block those who have harassed you (thus leaving a message in your inbox).
      #
      # @param message [String, RedditKit::PrivateMessage] A private message's full name, or a RedditKit::PrivateMessage.
      def block_author_of_message(message)
        parameters = { :id => extract_full_name(message) }
        post('api/block', parameters)
      end

      # Unblocks a user.
      #
      # @param user [String, RedditKit::User] A user's username, or a RedditKit::User.
      def unblock(user)
        enemy_name = extract_string(user, :username)
        friend_request 'unfriend', :container => current_user.full_name, :name => enemy_name, :type => :enemy
      end

    end
  end
end
