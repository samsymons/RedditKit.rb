require 'redditkit/link'

module RedditKit
  class Client

    # Methods for retrieving, submitting and interacting with links.
    module Links

      # Gets the links currently on the front page.
      #
      # @option options [hot, new, rising, controversial, top] :category The category from which to retrieve links.
      # @option options [hour, day, week, month, year, all] :time The time from which to retrieve links. Defaults to all time.
      # @option options [1..100] :limit The number of links to return.
      # @option options [String] :before Only return links before this identifier.
      # @option options [String] :after Only return links after this identifier.
      # @return [RedditKit::PaginatedResponse]
      def front_page(options = {})
        links nil, options
      end

      # Gets an array of links from a specific subreddit.
      #
      # @param subreddit [String, RedditKit::Subreddit] The display name of the subreddit, or a RedditKit::Subreddit.
      # @option options [hot, new, rising, controversial, top] :category The category from which to retrieve links.
      # @option options [hour, day, week, month, year, all] :time The time from which to retrieve links. Defaults to all time.
      # @option options [1..100] :limit The number of links to return.
      # @option options [String] :before Only return links before this identifier.
      # @option options [String] :after Only return links after this identifier.
      # @return [RedditKit::PaginatedResponse]
      def links(subreddit, options = {})
        subreddit_name = extract_string(subreddit, :display_name) if subreddit
        category = options[:category] || :hot

        path = "%s/#{category.to_s}.json" % ('r/' + subreddit_name if subreddit_name)

        options[:t] = options[:time] if options[:time]
        options.delete :category
        options.delete :time

        objects_from_response(:get, path, options)
      end

      # Gets a link object from its full name.
      #
      # @param link_full_name [String] The full name of the link.
      # @return [RedditKit::Link]
      # @note This method will return nil if there is not a user currently signed in.
      def link(link_full_name)
        links = objects_from_response(:get, 'api/info.json', { :id => link_full_name })
        links.first
      end

      # Gets links with a specific domain.
      #
      # @param domain [String] The domain for which to get links.
      # @option options [hour, day, week, month, year] :time The time from which to retrieve links. Defaults to all time.
      # @option options [1..100] :limit The number of links to return.
      # @option options [String] :before Only return links before this identifier.
      # @option options [String] :after Only return links after this identifier.
      # @return [RedditKit::PaginatedResponse]
      # @example links = RedditKit.links_with_domain "github.com"
      def links_with_domain(domain, options = {})
        parameters = { :url => domain, :t => options[:time] }
        options.merge! parameters
        options.delete :t

        objects_from_response(:get, 'api/info.json', options)
      end

      # Submits a link or self post to reddit.
      #
      # @param title [String] The title of the post.
      # @param subreddit [String, RedditKit::Subreddit] A subreddit's display name, or a RedditKit::Subreddit.
      # @option options [String] :url The URL for the post. Note that if this value is present, :text will be ignored.
      # @option options [String] :text The text value for the post, as Markdown.
      # @option options [String] :captcha_identifier An identifier for a CAPTCHA, if the current user is required to fill one out.
      # @option options [String] :captcha_value The value for the CAPTCHA with the given identifier, as filled out by the user.
      # @option options [Boolean] :save If true, the link will be implicitly saved after submission.
      def submit(title, subreddit, options = {})
        subreddit_name = extract_string subreddit, :display_name
        parameters = {
          :title => title,
          :sr => subreddit_name,
          :iden => options[:captcha_identifier],
          :captcha => options[:captcha_value],
          :save => options[:save]
          }

        if options[:url]
          parameters[:url] = options[:url]
          parameters[:kind] = 'link'
        else
          parameters[:text] = options[:text]
          parameters[:kind] = 'self'
        end

        post 'api/submit', parameters
      end

      # Marks a link as not safe for work.
      #
      # @param link [String, RedditKit::Link] A link's full name, or a RedditKit::Link.
      def mark_nsfw(link)
        post 'api/marknsfw', :id => extract_full_name(link)
      end

      # Marks a link as safe for work.
      #
      # @param link [String, RedditKit::Subreddit] A link's full name, or a RedditKit::Link.
      def mark_sfw(link)
        post 'api/unmarknsfw', :id => extract_full_name(link)
      end
      alias_method :unmark_nsfw, :mark_sfw

      # Hides a link.
      #
      # @param link [String, RedditKit::Link] A link's full name, or a RedditKit::Link.
      def hide(link)
        post 'api/hide', :id => extract_full_name(link)
      end

      # Unhides a link.
      #
      # @param link [String, RedditKit::Link] A link's full name, or a RedditKit::Link.
      def unhide(link)
        post 'api/unhide', :id => extract_full_name(link)
      end

      # Gets a random link.
      #
      # @return [RedditKit::Link]
      def random_link
        response = get('/random', nil)
        headers = response[:response_headers]
        location = headers[:location]

        link_id = location[/\/tb\/(.*)/, 1]
        link "t3_#{link_id}"
      end

    end
  end
end
