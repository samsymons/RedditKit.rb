require 'redditkit/paginated_response'

module RedditKit
  class Client

    # Methods for streamlining requests to reddit's servers.
    module Utilities

      private

      # Return an id from a string or a RedditKit::Thing object.
      #
      # @param object [String, RedditKit::Thing] A string or object.
      # @return [String]
      def extract_id(object)
        extract_string object, :id
      end

      # Return a full name from a string or a RedditKit::Thing object.
      #
      # @param object [String, RedditKit::Thing] A string or object.
      # @return [String]
      def extract_full_name(object)
        extract_string object, :full_name
      end

      def extract_string(object, attribute_name)
        case object
        when ::String
          object
        else
          object.send attribute_name if object.respond_to? attribute_name
        end
      end

      # Return the class of an object from a response.
      #
      # @param response [Faraday::Response] A response.
      # @return [Class]
      def object_class_from_response(response)
        kind = object_kind_from_response(response)
        object_class_from_kind(kind)
      end

      # Return the class of an object of a given kind.
      #
      # @param kind [String] The object's kind.
      # @return [Class]
      def object_class_from_kind(kind)
        case kind
        when 't1'
          RedditKit::Comment
        when 't2'
          RedditKit::User
        when 't3'
          RedditKit::Link
        when 't4'
          RedditKit::PrivateMessage
        when 't5'
          RedditKit::Subreddit
        when 'LabeledMulti'
          RedditKit::Multireddit
        when 'LabeledMultiDescription'
          RedditKit::MultiredditDescription
        when 'modaction'
          RedditKit::ModeratorAction
        end
      end

      def object_kind_from_response(response)
        response[:kind]
      end

      def object_from_response(request_type, path, parameters = {})
        response = send(request_type.to_sym, path, parameters)
        body = response[:body]

        object_class = object_class_from_response(body)
        object_class.new(body) if object_class
      end

      def objects_from_response(request_type, path, parameters = {})
        response = send(request_type.to_sym, path, parameters)
        body = response[:body]

        if body.is_a?(Hash) and body[:kind] == 'Listing'
          data = body[:data]
          results = objects_from_listing(body)

          RedditKit::PaginatedResponse.new(data[:before], data[:after], results)
        elsif body.is_a?(Array)
          objects_from_array body
        elsif body.is_a?(Hash)
          objects_from_array body[:data]
        end
      end

      def objects_from_listing(listing)
        children = listing[:data][:children]
        objects_from_array children
      end

      def objects_from_array(array)
        array.map do |thing|
          object_class = object_class_from_response(thing)
          object_class.new(thing) if object_class
        end
      end

      def comments_from_response(request_type, path, parameters = {})
        response = send(request_type.to_sym, path, parameters)
        body = response[:body]
        comments_listing = body.last

        objects_from_listing(comments_listing)
      end

      def path_for_multireddit(username, multireddit_name)
         "/user/#{username}/m/#{multireddit_name}"
      end

      # Performs a friend or unfriend request.
      #
      # @param type [friend, unfriend] The type of request.
      # @param options Any parameters to send with the request.
      def friend_request(type, options)
        if options[:subreddit]
          options[:r] = options[:subreddit]
          options.delete :subreddit
        end

        post("api/#{type}", options)
      end

    end
  end
end
