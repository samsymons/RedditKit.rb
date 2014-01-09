require 'redditkit/moderator_action'

module RedditKit
  class Client

    # Methods for moderating subreddits.
    module Moderation

      # Ban a user. This requires moderator privileges on the specified subreddit.
      #
      # @param user [String, RedditKit::User] The user's username, or a RedditKit::User.
      # @param subreddit [String, RedditKit::Subreddit] The subreddit's name, or a RedditKit::Subreddit.
      # @note If a subreddit's name is passed as the :subreddit option, a second HTTP request will be made to get the RedditKit::Subreddit object.
      def ban(user, subreddit)
        ban_or_unban_user true, user, subreddit
      end

      # Lift the ban on a user. This requires moderator privileges on the specified subreddit.
      #
      # @param user [String, RedditKit::User] The user's username, or a RedditKit::User.
      # @param subreddit [String, RedditKit::Subreddit] The subreddit's name, or a RedditKit::Subreddit.
      def unban(user, subreddit)
        ban_or_unban_user false, user, subreddit
      end

      # Approves an unmoderated link.
      #
      # @param link [String, RedditKit::Link] A link's full name, or a RedditKit::Link.
      def approve(link)
        full_name = extract_full_name link
        post 'api/approve', { :id => full_name, :api_type => :json }
      end

      # Removes a link or comment.
      #
      # @param object [String, RedditKit::Comment, RedditKit::Link] The full name of a link/comment, a RedditKit::Comment, or a RedditKit::Link.
      def remove(object)
        full_name = extract_full_name object
        post 'api/remove', { :id => full_name, :api_type => :json }
      end

      # Ignores the reports on a link or comment.
      #
      # @param object [String, RedditKit::Comment, RedditKit::Link] The full name of a link/comment, a RedditKit::Comment, or a RedditKit::Link.
      def ignore_reports(object)
        full_name = extract_full_name object
        post 'api/ignore_reports', { :id => full_name, :api_type => :json }
      end

      # Unignores the reports on a link or comment.
      #
      # @param object [String, RedditKit::Comment, RedditKit::Link] The full name of a link/comment, a RedditKit::Comment, or a RedditKit::Link.
      def unignore_reports(object)
        full_name = extract_full_name object
        post 'api/unignore_reports', { :id => full_name, :api_type => :json }
      end

      # Distinguishes a comment as being posted by a moderator or admin.
      #
      # @param comment [String, RedditKit::Comment] The full name of a comment, or a RedditKit::Comment.
      # @param how [yes, no, admin, special] How to distinguish the comment. Defaults to yes.
      # @note admin and special values may only be used if the current user has the right privileges.
      def distinguish(comment, how = 'yes')
        full_name = extract_full_name comment
        parameters = { :id => full_name, :api_type => :json }

        post "api/distinguish/#{how}", parameters
      end

      # Sets a post as have its contest mode enabled or disabled.
      #
      # @param link [String, RedditKit::Link] The full name of a link, or a RedditKit::Link.
      # @param contest_mode [Boolean] Whether to enable contest mode for the link's comments. Defaults to true.
      def set_contest_mode(link, contest_mode = true)
        set_boolean_on_link 'api/set_contest_mode', link, contest_mode
      end

      # Sets a post as sticky within its parent subreddit. This will replace the existing sticky post, if there is one.
      #
      # @param link [String, RedditKit::Link] The full name of a link, or a RedditKit::Link.
      # @param sticky [Boolean] Whether to mark the post as sticky or unsticky. Defaults to true.
      def set_sticky_post(link, sticky = true)
        set_boolean_on_link 'api/set_subreddit_sticky', link, sticky
      end

      # Get the moderators of a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] The display name of a subreddit, or a RedditKit::Subreddit.
      # @return [Array<OpenStruct>]
      def moderators_of_subreddit(subreddit)
        members_in_subreddit subreddit, 'moderators'
      end

      # Get the contributors to a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] The display name of a subreddit, or a RedditKit::Subreddit.
      # @return [Array<OpenStruct>]
      def contributors_to_subreddit(subreddit)
        members_in_subreddit subreddit, 'contributors'
      end

      # Accepts an invitation to become a moderator of a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] The display name of the subreddit, or a RedditKit::Subreddit.
      def accept_moderator_invitation(subreddit)
        subreddit_name = extract_string(subreddit, :display_name)
        post 'api/accept_moderator_invite', :r => subreddit_name
      end

      # Resign as a contributor to a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's full name, or a RedditKit::Subreddit.
      def resign_as_contributor(subreddit)
        full_name = extract_full_name subreddit
        post 'api/leavecontributor', :id => full_name
      end

      # Resign as a moderator of a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's full name, or a RedditKit::Subreddit.
      def resign_as_moderator(subreddit)
        full_name = extract_full_name subreddit
        post 'api/leavemoderator', :id => full_name
      end

      # Resets a subreddit's header image.
      #
      # @param subreddit [String, RedditKit::Subreddit] The display name of the subreddit, or a RedditKit::Subreddit.
      def reset_subreddit_header(subreddit)
        subreddit_name = extract_string(subreddit, :display_name)
        post 'api/delete_sr_header', :r => subreddit_name
      end

      # Gets the moderation log for a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's display name, or a RedditKit::Subreddit.
      # @return [RedditKit::PaginatedResponse]
      def moderation_log(subreddit)
        display_name = extract_string subreddit, :display_name
        objects_from_response(:get, "r/#{display_name}/about/log.json", nil)
      end

      private

      # Lift the ban on a user. This requires moderator privileges on the specified subreddit.
      #
      # @param ban [true, false] Whether to ban or unban the user.
      # @param user [String, RedditKit::User] The user's username, or a RedditKit::User.
      # @param subreddit [String, RedditKit::Subreddit] The subreddit's name, or a RedditKit::Subreddit.
      def ban_or_unban_user(ban, user, subreddit)
        username = extract_string(user, :username)
        subreddit_object = (subreddit.is_a? String) ? subreddit(subreddit) : subreddit
        friend_request_type = ban ? 'friend' : 'unfriend'

        friend_request friend_request_type, :container => subreddit_object.full_name, :name => username, :subreddit => subreddit_object.name, :type => :banned
      end

      # Gets members of a given type in a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's display name, or a RedditKit::Subreddit.
      # @param member_type [moderators, contributors] The type of members.
      def members_in_subreddit(subreddit, member_type)
        subreddit_name = extract_string(subreddit, :display_name)
        response = get("r/#{subreddit_name}/about/#{member_type}.json", nil)

        members = response[:body][:data][:children]
        members.collect { |member| OpenStruct.new(member) }
      end


      def set_boolean_on_link(path, link, boolean)
        full_name = extract_full_name link
        boolean_as_string = boolean ? 'True' : 'False'

        post path, { :id => full_name, :state => boolean_as_string, :api_type => :json }
      end

    end
  end
end
