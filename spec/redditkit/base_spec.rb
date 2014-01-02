require 'spec_helper'

describe RedditKit::Base do

  before do
    @base = RedditKit::Base.new(:kind => 't1', :data => {:id => '12345'})
    @thing = RedditKit::Thing.new(:kind => 't1', :data => {:id => '12345'})
  end

  describe "#attributes" do
    it "return a hash of attributes" do
      expect(@base.attributes).to eq(:kind => 't1', :id => '12345')
    end
  end

  describe "calling methods" do
    context "attribute method" do
      it "can access attribute methods" do
        expect(@thing.id).to eq '12345'
      end
    end

    context "predicate method" do
      it "can access predicate methods" do
        expect(@thing.id?).to be true
      end
    end

    context "#[]" do
      it "can call methods using strings" do
        expect(@base['object_id']).to be_an Integer
      end

      it "can call methods using symbols" do
        expect(@base[:object_id]).to be_an Integer
      end

      it "returns nil for nonexistent methods" do
        expect(@base['missing']).to be_nil
        expect(@base[:missing]).to be_nil
      end
    end
  end

end
