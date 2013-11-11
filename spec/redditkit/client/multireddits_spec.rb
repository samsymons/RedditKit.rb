require 'spec_helper'

describe RedditKit::Client::Multireddits, :vcr do

  describe "#my_multireddits" do
    it "return's the user's multireddits" do
      multireddits = authenticated_client.my_multireddits
      expect(multireddits).to_not be_nil
    end
  end

  describe "#multireddit" do
    context "with a path" do
      it "returns a multireddit" do
        multireddit = RedditKit.multireddit "/user/#{redditkit_username}/m/test"
        expect(multireddit.name).to eq 'test'
      end
    end

    context "without a path" do
      it "returns a multireddit" do
        multireddit = RedditKit.multireddit 'RedditKitTester', 'test'
        expect(multireddit.name).to eq 'test'
      end
    end
  end

  describe "#multireddit_description" do
    context "with a multireddit" do
      it "returns a multireddit description" do
        multireddit = RedditKit.multireddit 'RedditKitTester', 'test'

        multireddit_description = authenticated_client.multireddit_description multireddit
        expect(multireddit_description).to_not be_nil
      end
    end

    context "with a username and multireddit name" do
      it "returns a multireddit description" do
        multireddit_description = authenticated_client.multireddit_description 'RedditKitTester', 'test'
        expect(multireddit_description).to_not be_nil
      end
    end
  end

  describe "#set_multireddit_description" do
    it "returns a multireddit description" do
      multireddit_description = authenticated_client.set_multireddit_description 'test', 'New description'
      expect(multireddit_description.text).to eq 'New description'
    end
  end

  describe "#delete_multireddit" do
    it "deletes a multireddit" do
      multireddit_name = 'testmultireddit'

      authenticated_client.create_multireddit multireddit_name, %w(ruby objectivec)
      authenticated_client.delete_multireddit multireddit_name

      multireddits = authenticated_client.my_multireddits
      multireddit = multireddits.find { |multi| multi.name == multireddit_name }

      expect(multireddit).to be_nil
    end
  end

  describe "#create_multireddit" do
    it "creates a multireddit" do
      multireddit_name = 'testmultireddit'
      authenticated_client.create_multireddit multireddit_name, %w(ruby objectivec)

      multireddits = authenticated_client.my_multireddits
      multireddit = multireddits.find { |multi| multi.name == multireddit_name }

      expect(multireddit).to_not be_nil

      authenticated_client.delete_multireddit multireddit_name
    end

    it "raises RedditKit::Conflict when using an existing name" do
      authenticated_client.create_multireddit 'conflictedmultireddit'

      expect { authenticated_client.create_multireddit 'conflictedmultireddit' }.to raise_error RedditKit::Conflict

      authenticated_client.delete_multireddit 'conflictedmultireddit'
    end
  end

  describe "#update_multireddit" do
    it "updates a multireddit" do
      multireddit_name = 'testmultireddit'
      authenticated_client.create_multireddit multireddit_name, %w(ruby objectivec)
      authenticated_client.update_multireddit multireddit_name, %w(ruby objectivec haskell)

      multireddits = authenticated_client.my_multireddits
      multireddit = multireddits.find { |multi| multi.name == multireddit_name }

      expect(multireddit.subreddits.include? 'haskell').to be_true

      authenticated_client.delete_multireddit multireddit_name
    end
  end

  describe "#copy_multireddit" do
    before do
      stub_empty_post_request 'api/multi/copy'
    end

    it "requests the correct resource" do
      authenticated_client.copy_multireddit :user => 'somefakeusername', :multireddit => 'multireddit', :name => 'multireddit'
      expect(a_post('api/multi/copy')).to have_been_made
    end
  end

  describe "#rename_multireddit" do
    it "renames a multireddit" do
      old_name = 'multireddittorename'
      new_name = 'renamedmultireddit'

      authenticated_client.create_multireddit old_name

      multireddit = authenticated_client.rename_multireddit old_name, new_name
      expect(multireddit.name).to eq new_name

      authenticated_client.delete_multireddit new_name
    end
  end

  describe "#delete_multireddit" do
  end

  describe "#add_subreddit_to_multireddit" do
    it "adds a subreddit to a multireddit" do
      authenticated_client.create_multireddit 'addsubreddit', %w(ruby objectivec)

      authenticated_client.add_subreddit_to_multireddit 'addsubreddit', 'haskell'
      multireddit = authenticated_client.multireddit redditkit_username, 'addsubreddit'

      expect(multireddit.subreddits.include? 'haskell').to be_true

      authenticated_client.delete_multireddit 'addsubreddit'
    end
  end

  describe "#remove_subreddit_from_multireddit" do
    it "removes a subreddit from a multireddit" do
      authenticated_client.create_multireddit 'removesubreddit', %w(ruby objectivec haskell)

      authenticated_client.remove_subreddit_from_multireddit 'removesubreddit', 'haskell'
      multireddit = authenticated_client.multireddit redditkit_username, 'removesubreddit'

      expect(multireddit.subreddits.include? 'haskell').to be_false

      authenticated_client.delete_multireddit 'removesubreddit'
    end
  end

end
