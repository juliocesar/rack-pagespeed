source :rubygems

# Include all the gems from the Gemspec
gemspec

gem 'rack'    # Just let it work with latest. If the API breaks, I'll fix it
gem 'nokogiri'
gem 'jsmin'
gem 'dalli'

# Required for development
gem 'rake'
gem 'jeweler'

group :test do
  gem 'rspec',    '2.6.0'
  gem 'capybara', '1.0.0'
  gem 'redis'
  gem 'memcached'
end
