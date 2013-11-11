require 'spec_helper'

describe RedditKit::Creatable do

  class CreatableClass
    def initialize
      @time = Time.new(2000)
      @attributes = { :created_utc => @time.to_i }
    end
  end

  before :all do
    @creatable = CreatableClass.new
    @creatable.extend RedditKit::Creatable
  end

  describe "#created_at" do
    it "returns the time the object was created at" do
      created_at = @creatable.created_at 
      expect(created_at.year).to eq 2000
    end
  end

end
