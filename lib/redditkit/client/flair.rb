require 'ostruct'

module RedditKit
  class Client

    # Methods for interacting with flair in subreddits.
    module Flair

      # Lists users and their flair in a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's name, or a RedditKit::Subreddit.
      # @option options [1..1000] :limit The number of items to return.
      # @option options [String] :before Only return objects before this id.
      # @option options [String] :after Only return objects after this id.
      def flair_list(subreddit, options = {})
        subreddit_name = extract_string(subreddit, :display_name)
        list = get("/r/#{subreddit_name}/api/flairlist.json", options)
        users = list[:body][:users]

        users.collect { |user| OpenStruct.new(user) }
      end

      # Creates a flair template in a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's name, or a RedditKit::Subreddit.
      # @param type [user, link] The template's type. Defaults to user.
      # @option options [String] text The text value for the template.
      # @option options [String] css_class The CSS class for the template.
      # @option options [Boolean] user_editable Whether the template should be editable by users.
      def create_flair_template(subreddit, type, options = {})
        subreddit_name = extract_string(subreddit, :display_name)
        flair_type = (type.to_s == 'link') ? 'LINK_FLAIR' : 'USER_FLAIR'

        parameters = { :r => subreddit_name, :flair_type => flair_type, :text => options[:text], :css_class => options[:css_class], :api_type => :json }
        parameters[:text_editable] = 'on' if options[:user_editable]

        post('api/flairtemplate', parameters)
      end

      # Deletes a flair template.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's name, or a RedditKit::Subreddit.
      # @param template_identifier [String] The template's identifier.
      def delete_flair_template(subreddit, template_identifier)
        subreddit_name = extract_string(subreddit, :display_name)
        parameters = { :flair_template_id => template_identifier, :r => subreddit_name }

        post('api/deleteflairtemplate', parameters)
      end

      # Toggles flair for a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's name, or a RedditKit::Subreddit.
      # @param flair_enabled [Boolean] Whether to enable flair for the subreddit.
      def toggle_flair(subreddit, flair_enabled)
        post('api/setflairenabled', { :r => subreddit, :flair_enabled => flair_enabled })
      end

      # Sets flair on a link or user.
      #
      # @option options [String, RedditKit::Subreddit] subreddit A subreddit's name, or a RedditKit::Subreddit.
      # @option options [String] text The text value for the template.
      # @option options [String] css_class The CSS class for the template.
      # @option options [String, RedditKit::Link] link A link's full name, or a RedditKit::Link.
      # @option options [String, RedditKit::User] user A user's username, or a RedditKit::User.
      # @note Raises RedditKit::BadClassName if any CSS classes contain invalid characters, or RedditKit::TooManyClassNames if there are too many.
      def set_flair(options)
        subreddit_name = extract_string(options[:subreddit], :display_name)
        link_full_name = extract_full_name options[:link]
        username = extract_string options[:user], :username

        parameters = { :r => subreddit_name, :text => options[:text], :css_class => options[:css_class], :name => username, :link => link_full_name }

        post('api/flair', parameters)
      end

      # Sets a subreddit's flair using a string formatted as CSV.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's name, or a RedditKit::Subreddit.
      # @param csv_string [String] A string in CSV format.
      # @note Each line in the string should be in the format 'user,flair-text,css_class'.
      def set_flair_with_csv(subreddit, csv_string)
        subreddit_name = extract_string(subreddit, :display_name)
        parameters = { :r => subreddit_name, :flair_csv => csv_string }

        post('api/flaircsv', parameters)
      end

      # Clears a user's flair.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's name, or a RedditKit::Subreddit.
      # @param user [String, RedditKit::User] A subreddit's name, or a RedditKit::Subreddit.
      def delete_user_flair(subreddit, user)
        subreddit_name = extract_string(subreddit, :display_name)
        username = extract_string(user, :username)
        parameters = { :name => username, :r => subreddit_name }

        post('api/deleteflair', parameters)
      end

      # Clears all flair templates of a certain type.
      #
      # @option options [String, RedditKit::Subreddit] subreddit A subreddit's name, or a RedditKit::Subreddit.
      # @option options [user, link] type The template's type. Defaults to user.
      def clear_flair_templates(options)
        subreddit_name = extract_string(options[:subreddit], :display_name)
        flair_type = 'USER_FLAIR'
        flair_type = 'LINK_FLAIR' if options[:type].to_s == 'link'

        parameters = { :r => subreddit_name, :flair_type => flair_type, :text => options[:text], :css_class => options[:css_class] }

        post('api/clearflairtemplates', parameters)
      end

      # Applys a flair template to a link or user.
      #
      # @option options [String, RedditKit::Subreddit] subreddit A subreddit's name, or a RedditKit::Subreddit.
      # @option options [String] template_id The template's identifier.
      # @option options [String, RedditKit::Link] link A link's full name, or a RedditKit::Link.
      # @option options [String, RedditKit::User] user A user's username, or a RedditKit::User.
      def apply_flair_template(options)
        subreddit_name = extract_string(options[:subreddit], :display_name)
        link_full_name = extract_full_name options[:link]
        username = extract_string options[:user], :username

        parameters = { :flair_template_id => options[:template_id], :r => subreddit_name, :name => username, :link => link_full_name }

        post('api/selectflair', parameters)
      end

      # Sets flair options for a subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's name, or a RedditKit::Subreddit.
      # @option options [Boolean] flair_enabled Whether to enable flair for the subreddit.
      # @option options [left, right] flair_position The position of user flair.
      # @option options [left, right] link_flair_position The position of link flair.
      # @option options [Boolean] flair_self_assign_enabled Whether users may assign their own flair.
      # @option options [Boolean] link_flair_self_assign_enabled Whether users may assign their own link flair.
      def set_flair_options(subreddit, options = {})
        subreddit_name = extract_string(subreddit, :display_name)
        options.merge!({ :r => subreddit_name, :uh => @modhash })

        post('api/flairconfig', options)
      end

    end
  end
end
