module RedditKit
  class Client

    # Methods for retrieving and submitting CAPTCHAs.
    module Captcha

      # Whether the current user will need to answer a CAPTCHA for methods which may require one.
      #
      # @return [Boolean]
      def needs_captcha?
        response = get 'api/needs_captcha.json'
        needs_captcha = response[:body]

        needs_captcha.to_s == 'true'
      end

      # Returns a new CATPCHA identifier.
      #
      # @return [String] The CAPTCHA identifier.
      def new_captcha_identifier
        response = post 'api/new_captcha', :api_type => :json
        data = response[:body][:json][:data]

        data[:iden]
      end

      # Returns the URL for a CAPTCHA image with a given identifier.
      #
      # @return [String]
      def captcha_url(captcha_identifier)
        "http://reddit.com/captcha/#{captcha_identifier}.png"
      end

    end
  end
end
