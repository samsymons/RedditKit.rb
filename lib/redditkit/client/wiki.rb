module RedditKit
  class Client

    # Methods for interacting with a subreddit's wiki.
    module Wiki

      # Adds a user as an approved editor of a wiki page.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's display name, or a RedditKit::Subreddit.
      # @param user [String, RedditKit::User] A user's full name, or a RedditKit::User.
      # @param page [String] page The name of an existing wiki page.
      def add_wiki_editor(subreddit, user, page)
        toggle_wiki_editor(subreddit, user, page, 'add')
      end

      # Removes a user from being an approved editor of a wiki page.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's display name, or a RedditKit::Subreddit.
      # @param user [String, RedditKit::User] A user's full name, or a RedditKit::User.
      # @param page [String] page The name of an existing wiki page.
      def remove_wiki_editor(subreddit, user, page)
        toggle_wiki_editor(subreddit, user, page, 'del')
      end

      # Edits a wiki page.
      #
      # @option options [String, RedditKit::Subreddit] subreddit A subreddit's display name, or a RedditKit::Subreddit.
      # @option options [String] page The name of an existing wiki page.
      # @option options [String] content The contents of the edit.
      # @option options [String] reason The reason for the edit.
      # @option options [String] previous_revision The starting revision for this edit.
      def edit_wiki_page(options)
        subreddit_name = extract_string(options[:subreddit], :display_name)
        parameters = { :page => options[:page], :previous => options[:previous_revision], :content => options[:content], :reason => options[:reason] }

        post("r/#{subreddit_name}/api/wiki/edit", parameters)
      end

      # Hides a wiki page revision. If the revision is already hidden, this will unhide it.
      #
      # @option options [String, RedditKit::Subreddit] subreddit A subreddit's display name, or a RedditKit::Subreddit.
      # @option options [String] page The name of an existing wiki page.
      # @option options [String] revision The revision to hide.
      # @return [Boolean] True if the revision is now hidden, false if it is not hidden.
      def hide_wiki_revision(options)
        subreddit_name = extract_string(options[:subreddit], :display_name)
        options.delete :subreddit

        response = post("r/#{subreddit_name}/api/wiki/hide", options)
        response[:body][:status]
      end

      # Reverts to a specific wiki page revision.
      #
      # @option options [String, RedditKit::Subreddit] subreddit A subreddit's display name, or a RedditKit::Subreddit.
      # @option options [String] page The name of an existing wiki page.
      # @option options [String] revision The revision to revert to.
      def revert_to_revision(options)
        subreddit_name = extract_string(options[:subreddit], :display_name)
        options.delete :subreddit

        post("r/#{subreddit_name}/api/wiki/revert", options)
      end

      private

      # Adds or removes a user as an approved editor of a wiki page.
      #
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's display name, or a RedditKit::Subreddit.
      # @param user [String, RedditKit::User] A user's full name, or a RedditKit::User.
      # @param page [String] page The name of an existing wiki page.
      # @param status [add, del] Whether to add or delete a user.
      def toggle_wiki_editor(subreddit, user, page, status)
        subreddit_name = extract_string(subreddit, :display_name)
        username = extract_string(user, :username)
        parameters = { :page => page, :username => username }

        post("r/#{subreddit_name}/api/wiki/alloweditor/#{status}", parameters)
      end

    end
  end
end
