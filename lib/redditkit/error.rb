require 'json'

module RedditKit
  class Error < StandardError
    class << self

      def from_status_code_and_body(status_code, body)
        error_value = extract_error_value body
        return if status_code == 200 && error_value.nil?

        case status_code
        when 200
          if error_value =~ /WRONG_PASSWORD/i
            RedditKit::InvalidCredentials
          elsif error_value =~ /BAD_CAPTCHA/i
            RedditKit::InvalidCaptcha
          elsif error_value =~ /RATELIMIT/i
            RedditKit::RateLimited
          elsif error_value =~ /BAD_CSS_NAME/i
            RedditKit::InvalidClassName
          elsif error_value =~ /TOO_OLD/i
            RedditKit::Archived
          elsif error_value =~ /TOO_MUCH_FLAIR_CSS/i
            RedditKit::TooManyClassNames
          elsif error_value =~ /USER_REQUIRED/i
            RedditKit::AuthenticationRequired
          end
        when 400
          if error_value =~ /BAD_MULTI_NAME/i
            RedditKit::InvalidMultiredditName
          end
        when 403
          if error_value =~ /USER_REQUIRED/i
            RedditKit::AuthenticationRequired
          else
            RedditKit::PermissionDenied
          end
        when 409
          RedditKit::Conflict
        when 500
          RedditKit::InternalServerError
        when 502
          RedditKit::BadGateway
        when 503
          RedditKit::ServiceUnavailable
        when 504
          RedditKit::TimedOut
        end
      end

      private

      def extract_error_value(body)
        return nil unless body.instance_of? Hash

        if body.key?(:json) && body[:json].key?(:errors)
          body[:json][:errors].to_s
        elsif body.key?(:jquery)
          body[:jquery].to_s
        end
      end

    end
  end

  # Raised when there should be an authenticated user, but there isn't.
  class AuthenticationRequired < Error; end

  # Raised when the user passes an invalid CAPTCHA identifier or value.
  class InvalidCaptcha < Error; end

  # Raised when reddit returns a 503 status code.
  class BadGateway < Error; end

  # Raised when the user attempts to create a multireddit with an invalid name.
  class InvalidMultiredditName < Error; end

  # Raised when reddit returns a 409 status code.
  class Conflict < Error; end

  # Raised when reddit returns a 500 status code.
  class InternalServerError < Error; end

  # Raised when the user passes an invalid CSS class name.
  class InvalidClassName < Error; end

  # Raised when the user attempts to sign in with an incorrect username or password.
  class InvalidCredentials < Error; end

  # Raised when the user attempts to access a resource without the appropriate permissions.
  class PermissionDenied < Error; end

  # Raised when the user has been rate limited.
  class RateLimited < Error; end

  # Raised when RedditKit encounters an error with one of its own requests.
  class RequestError < Error; end

  # Raised when reddit is unavailable.
  class ServiceUnavailable < Error; end

  # Raised when too many CSS class names are passed.
  class TooManyClassNames < Error; end

  # Raised when the user attempts to interact with an item that has been archived.
  class Archived < Error; end

  # Raised when reddit's returns a 504 status code.
  class TimedOut < Error; end

end
