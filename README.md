# RedditKit.rb

RedditKit.rb is a [reddit API](http://www.reddit.com/dev/api) wrapper, written in Ruby.

[![Gem Version](https://badge.fury.io/rb/redditkit.png)][rubygem]
[![Build Status](https://travis-ci.org/samsymons/RedditKit.rb.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/samsymons/RedditKit.rb.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/samsymons/RedditKit.rb/badge.png?branch=master)][coveralls]

[rubygem]: https://rubygems.org/gems/redditkit
[travis]: https://travis-ci.org/samsymons/RedditKit.rb
[codeclimate]: https://codeclimate.com/github/samsymons/RedditKit.rb
[coveralls]: https://coveralls.io/r/samsymons/RedditKit.rb

## Documentation

[http://rdoc.info/gems/redditkit/](http://rdoc.info/gems/redditkit/)

## Installation

Add this to your Gemfile:

    gem 'redditkit', '~> 1.0.1'

Or install it directly:

    gem install redditkit

## Getting Started

RedditKit.rb is structured closely to the wonderful [Octokit.rb](https://github.com/octokit/octokit.rb) and [Twitter](https://github.com/sferik/twitter) gems. If you're familiar with either of those, you'll feel right at home here. You can find the [project's documentation on the RedditKit website](http://redditkit.com/redditkit.rb/).

RedditKit.rb is used through either the `RedditKit` module, or `RedditKit::Client` objects, like so:

**Module usage:**
```ruby
RedditKit.sign_in 'username', 'password'
RedditKit.user_agent = 'MyRedditBot/1.2 (+http://www.reddit.com/user/username)'
subreddits = RedditKit.subscribed_subreddits
```

**Instance method usage:**
```ruby
client = RedditKit::Client.new 'username', 'password','MyRedditBot','1.2'
subreddits = client.subscribed_subreddits
```

Using RedditKit.rb at the module level allows you to use a single account without having to keep track of RedditKit::Client instances. Working at the instance method level makes it possible to use multiple accounts at once, with one client object per account.

> RedditKit.rb doesn't have any built-in rate limiting. reddit's API rules require that you make no more than 30 requests per minute and try to avoid requesting the same page more than once every 30 seconds. You can read up on the API rules [on their wiki page](https://github.com/reddit/reddit/wiki/API).

### Authentication

```ruby
client = RedditKit::Client.new 'username', 'password'
client.signed_in? # => true
```

## More Examples

**Fetch a user and check their link karma:**

```ruby
user = RedditKit.user 'samsymons'
puts "#{user.username} has #{user.link_karma} link karma."
```

**Subscribe to a subreddit:**

```ruby
authenticated_client = RedditKit::Client.new 'samsymons', 'password'
authenticated_client.subscribe 'ruby'
```

**Upvote the top post in a subreddit:**

```ruby
posts = authenticated_client.posts 'programming', :category => :top, :time => :all
authenticated_client.upvote posts.first
```

**Send private messages:**

```ruby
authenticated_client.send_message 'How are you?', 'amberlynns', :subject => 'Hi!'
```

## Pagination

Some RedditKit.rb methods accept pagination options and return `RedditKit::PaginatedResponse` objects upon completion. These options allow you to, for example, limit the number of results returned, or fetch results before/after a specific object.

`RedditKit::PaginatedResponse` forwards its enumeration methods to its `results` array, so you can iterate over it like you would with a standard array.

``` ruby
paginated_response = RedditKit.front_page

paginated_response.each do |link|
  # Do something with each link.
end
```

## Configuration

You can configure various aspects of RedditKit.rb's operation, including its default API endpoint and user agent, by setting attributes on `RedditKit::Client`.

**You should set your user agent to the name and version of your app, along with your reddit username. That way, if you ever have a buggy version of your app abusing the API, the reddit admins will know who to contact.
```ruby
#Option 1
MY_BOT_VERSION = 1.7
client = RedditKit::Client.new 'myRedditUserName','password','myBotName',MY_BOT_VERSION
puts client.user_agent
# yields "myRedditUserName/1.7 (+http://www.reddit.com/user/myRedditUserName)"

#Option 2
client = RedditKit::Client.new 'myRedditUserName','password'
client.user_agent_name = 'myBotName'
client.user_agent_version = MY_BOT_VERSION
#This also works with the module usage pattern
RedditKit.sign_in 'myRedditUserName','password'
RedditKit.user_agent_name = 'myBotName'
RedditKit.user_agent_version = MY_BOT_VERSION

#Option 3
client = RedditKit::Client.new 'myRedditUserName','password'
client.user_agent='myCustomAgentString/0.4 (+http://example.com/contact/info.html)'
#This also works with the module usage pattern
RedditKit.sign_in 'myRedditUserName','password'
RedditKit.user_agent='myCustomAgentString/0.4 (+http://example.com/contact/info.html)'
```

## Contributing

### Debugging

Because RedditKit.rb is built atop Faraday, you can modify its middleware stack to add new behaviour. This is particularly handy for debugging as you can turn on Faraday's response logger.

```ruby
RedditKit.middleware = Faraday::Builder.new do |builder|
  builder.use Faraday::Request::UrlEncoded
  builder.use RedditKit::Response::RaiseError
  builder.use RedditKit::Response::ParseJSON
  builder.use Faraday::Response::Logger  
  builder.adapter Faraday.default_adapter
end
```

### Writing Tests

Tests assume the presence of a `.env` file at the project's root. This file should contain the following three environment variables:

* `REDDITKIT_TEST_USERNAME` The username of a reddit account dedicated solely to testing.
* `REDDITKIT_TEST_PASSWORD` The password for the reddit account.
* `REDDITKIT_TEST_SUBREDDIT` A subreddit for which the provided reddit account has admin privileges. This subreddit should be also be dedicated to testing as the test suite will run many different methods on it, creating & deleting various resources.

## Requirements

Ruby 1.9.3 and Ruby 2.0.0 are officially supported.

## Need Help?

Open an [issue](https://github.com/samsymons/RedditKit.rb/issues), or hit me up on [Twitter](http://twitter.com/sam_symons).

## License

Copyright (c) 2013 Sam Symons (http://samsymons.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
