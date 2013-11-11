require 'redditkit/moderator_action'

module RedditKit
  class Client

    # Methods for moderating subreddits.
    module Moderation

      # Ban a user. This requires moderator privileges on the specified subreddit.
      #
      # @option options [String, RedditKit::User] user The user's username, or a RedditKit::User.
      # @option options [String, RedditKit::Subreddit] subreddit The subreddit's name, or a RedditKit::Subreddit.
      # @note If a subreddit's name is passed as the :subreddit option, a second HTTP request will be made to get the RedditKit::Subreddit object.
      def ban(options)
        subreddit_object = options[:subreddit]
        subreddit_object = subreddit(subreddit_object) if subreddit_object.is_a? String

        friend_request :container => subreddit_object.full_name, :name => options[:user], :subreddit => subreddit_object.name, :type => :banned
      end

      # Lift the ban on a user. This requires moderator privileges on the specified subreddit.
      #
      # @option options [String, RedditKit::User] user The user's username, or a RedditKit::User.
      # @option options [RedditKit::Subreddit] subreddit The subreddit in which to ban the user.
      def unban(options)
        subreddit_object = options[:subreddit]
        subreddit_object = subreddit(subreddit_object) if subreddit_object.is_a? String

        unfriend_request :container => subreddit_object.full_name, :name => options[:user], :subreddit => subreddit_object.name, :type => :banned
      end

      # Approves an unmoderated link.
      #
      # @param link [String, RedditKit::Link] A link's full name, or a RedditKit::Link.
      def approve(link)
        full_name = extract_full_name link
        post('api/approve', { :id => full_name, :api_type => :json })
      end

      # Removes a link or comment.
      #
      # @param object [String, RedditKit::Comment, RedditKit::Link] The full name of a link/comment, a RedditKit::Comment, or a RedditKit::Link.
      def remove(object)
        full_name = extract_full_name object
        post('api/remove', { :id => full_name, :api_type => :json })
      end

      # Ignores the reports on a link or comment.
      #
      # @param object [String, RedditKit::Comment, RedditKit::Link] The full name of a link/comment, a RedditKit::Comment, or a RedditKit::Link.
      def ignore_reports(object)
        full_name = extract_full_name object
        post('api/ignore_reports', { :id => full_name, :api_type => :json })
      end

      # Unignores the reports on a link or comment.
      #
      # @param object [String, RedditKit::Comment, RedditKit::Link] The full name of a link/comment, a RedditKit::Comment, or a RedditKit::Link.
      def unignore_reports(object)
        full_name = extract_full_name object
        post('api/unignore_reports', { :id => full_name, :api_type => :json })
      end

      # Distinguishes a comment as being posted by a moderator or admin.
      #
      # @option options [String, RedditKit::Comment] comment The full name of a comment, or a RedditKit::Comment.
      # @option options [yes, no, admin, special] distinguish How to distinguish the comment. Defaults to yes.
      # @note admin and special values may only be used if the current user has the right privileges.
      def distinguish(options)
        full_name = extract_full_name options[:comment]
        how = options[:distinguish] || :yes
        parameters = { :id => full_name, :api_type => :json }

        post("api/distinguish/#{how}", parameters)
      end

      # Sets a post as have its contest mode enabled or disabled.
      #
      # @param link [String, RedditKit::Link] The full name of a link, or a RedditKit::Link.
      # @option options [Boolean] enabled Whether to enable contest mode for the link's comments.
      def set_contest_mode(link, options = {})
        full_name = extract_full_name link
        enabled = options[:enabled] ? 'True' : 'False'

        post('api/set_contest_mode', { :id => full_name, :state => enabled, :api_type => :json })
      end
      
      # Sets a post as sticky within its parent subreddit. This will replace the existing sticky post, if there is one.
      #
      # @param link [String, RedditKit::Link] The full name of a link, or a RedditKit::Link.
      # @option options [Boolean] sticky Whether to mark the post as sticky or unsticky (true for sticky, false for unsticky).
      def set_sticky_post(link, options = {})
        full_name = extract_full_name link
        sticky = options[:sticky] ? 'True' : 'False'

        post('api/set_subreddit_sticky', { :id => full_name, :state => sticky, :api_type => :json })
      end

      # Get the moderators of a subreddit.
      # 
      # @param subreddit [String, RedditKit::Subreddit] The display name of a subreddit, or a RedditKit::Subreddit.
      # @return [Array<OpenStruct>]
      def moderators_of_subreddit(subreddit)
        subreddit_name = extract_string(subreddit, :display_name)
        response = get("r/#{subreddit_name}/about/moderators.json", nil)

        moderators = response[:body][:data][:children]
        moderators.collect { |moderator| OpenStruct.new(moderator) }
      end

      # Get the contributors to a subreddit.
      # 
      # @param subreddit [String, RedditKit::Subreddit] The display name of a subreddit, or a RedditKit::Subreddit.
      # @return [Array<OpenStruct>]
      def contributors_to_subreddit(subreddit)
        subreddit_name = extract_string(subreddit, :display_name)
        response = get("r/#{subreddit_name}/about/contributors.json", nil)

        contributors = response[:body][:data][:children]
        contributors.collect { |contributor| OpenStruct.new(contributor) }
      end

      # Accepts an invitation to become a moderator of a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] The display name of the subreddit, or a RedditKit::Subreddit.
      def accept_moderator_invitation(subreddit)
        subreddit_name = extract_string(subreddit, :display_name)
        post('api/accept_moderator_invite', { :r => subreddit_name })
      end

      # Resign as a contributor to a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's full name, or a RedditKit::Subreddit.
      def resign_as_contributor(subreddit)
        full_name = extract_full_name subreddit
        post('api/leavecontributor', { :id => full_name })
      end
      
      # Resign as a moderator of a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's full name, or a RedditKit::Subreddit.
      def resign_as_moderator(subreddit)
        full_name = extract_full_name subreddit
        post('api/leavemoderator', { :id => full_name })
      end

      # Resets a subreddit's header image.
      #
      # @param subreddit [String, RedditKit::Subreddit] The display name of the subreddit, or a RedditKit::Subreddit.
      def reset_subreddit_header(subreddit)
        subreddit_name = extract_string(subreddit, :display_name)
        post('api/delete_sr_header', { :r => subreddit_name })
      end

      # Configures a subreddit's settings.
      #
      # @option parameters [String] title The subreddit's title (this is the value that will in a browser's title bar, not the subreddit's name).
      # @option parameters [String] description The subreddit's description.
      # @option parameters [Boolean] over_18 Whether the subreddit requires visitors to be over 18.
      def set_subreddit_settings(parameters)
      end

      # Gets the moderation log for a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's display name, or a RedditKit::Subreddit.
      # @return [RedditKit::PaginatedResponse]
      def moderation_log(subreddit)
        display_name = extract_string subreddit, :display_name
        objects_from_response(:get, "r/#{display_name}/about/log.json", nil)
      end

    end
  end
end
