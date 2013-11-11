require 'spec_helper'

describe RedditKit::PaginatedResponse do

  before :all do
    @response = RedditKit::PaginatedResponse.new('12345', '54321', %w(one two three))
  end

  it "contains pagination information" do
    expect(@response.before).to eq '12345'
    expect(@response.after).to eq '54321'
  end

  it "contains results" do
    expect(@response.results.length).to eq 3
  end

  it "forwards array methods" do
    expect(@response.first).to eq 'one'
    expect(@response.length).to eq 3
  end

end
