source 'https://rubygems.org'

ruby '2.0.0'

# Server
gem 'rails', '4.0.0.beta1'
gem 'unicorn'

# Templating and UI
gem 'haml'
gem 'haml-rails'
gem 'sass'
gem 'jquery-rails'
gem 'turbolinks'

# Authentication
gem 'omniauth'
gem 'omniauth-twitter'

# Database
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'bson_ext'

# Utility
gem 'twitter'
gem 'typhoeus'

group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'database_cleaner'
end

group :development do
  gem 'guard'
  gem 'rb-fsevent', require: ('rb-fsevent' if RUBY_PLATFORM =~ /darwin/i)
  gem 'guard-rake'
  gem 'guard-bundler'
  gem 'guard-rspec'
end

group :test do
  gem 'vcr'
end