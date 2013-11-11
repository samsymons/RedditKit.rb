require 'spec_helper'

describe RedditKit::Error do

  describe "#from_status_code_and_body" do

    it "returns no error for a valid body" do
      error = RedditKit::Error.from_status_code_and_body(200, {})
      expect(error).to be_nil
    end

    it "returns RedditKit::AuthenticationRequired for the USER_REQUIRED error" do
      body = { :jquery => "USER_REQUIRED" }
      error = RedditKit::Error.from_status_code_and_body(200, body)
      expect(error).to eq RedditKit::AuthenticationRequired
    end

    it "returns RedditKit::AuthenticationRequired for the RATELIMIT error" do
      body = { :jquery => "RATELIMIT" }
      error = RedditKit::Error.from_status_code_and_body(200, body)
      expect(error).to eq RedditKit::RateLimited
    end

    it "returns RedditKit::Archived for the TOO_OLD error" do
      body = { :jquery => "TOO_OLD" }
      error = RedditKit::Error.from_status_code_and_body(200, body)
      expect(error).to eq RedditKit::Archived
    end

    it "returns RedditKit::PermissionDenied for status code 403" do
      body = { :jquery => "ERROR" }
      error = RedditKit::Error.from_status_code_and_body(403, body)
      expect(error).to eq RedditKit::PermissionDenied
    end

    it "returns RedditKit::Conflict for status code 409" do
      body = { :jquery => "ERROR" }
      error = RedditKit::Error.from_status_code_and_body(409, body)
      expect(error).to eq RedditKit::Conflict
    end

    it "returns RedditKit::InternalServerError for status code 500" do
      body = { :jquery => "ERROR" }
      error = RedditKit::Error.from_status_code_and_body(500, body)
      expect(error).to eq RedditKit::InternalServerError
    end

    it "returns RedditKit::BadGateway for status code 502" do
      body = { :jquery => "ERROR" }
      error = RedditKit::Error.from_status_code_and_body(502, body)
      expect(error).to eq RedditKit::BadGateway
    end

    it "returns RedditKit::ServiceUnavailable for status code 503" do
      body = { :jquery => "ERROR" }
      error = RedditKit::Error.from_status_code_and_body(503, body)
      expect(error).to eq RedditKit::ServiceUnavailable
    end
  end

end
