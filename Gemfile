source 'https://rubygems.org'

gem 'rake'
gem 'coveralls', require: false

group :development do
  gem 'guard-rspec'
  gem 'guard-yard'
  gem 'pry'
  gem 'yard'
end

group :test do
  gem 'rspec'
  gem 'simplecov', :require => false
  gem 'vcr', '~> 2.6.0'
  gem 'webmock', '~> 1.12.0'
end

platforms :rbx do
  gem 'rubysl', '~> 2'
  gem 'racc', '~> 1.4'
end

gemspec
