source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'rails', '~> 6.0.4.8'
gem 'mysql2'

gem 'devise'
gem 'devise-jwt'
gem 'jbuilder', '~> 2.9'

gem 'jsonapi-serializer'
gem "jsonapi-rails"
gem 'aws-sdk-s3', '~> 1'
gem 'paperclip'
gem 'kaminari'
gem 'yard'
gem "faraday" #, '~> 0.8'
gem 'httpclient'
gem "jwt"

# zip files
gem 'rubyzip'
gem 'acts_as_paranoid'
gem 'paper_trail'
gem 'httparty'
gem 'curb', '~> 0.9.10'
# translations
gem "globalize", "~> 5.3.0"
gem "globalize-accessors", "~> 0.2.1"

gem 'exception_notification'
gem 'activerecord-import', '~> 1.2'
gem 'smarter_csv'
gem 'msgpack'
# fixed snyk Vulnerabilities
gem "json", ">= 2.3.0"
gem 'puma', '~> 5.2'
gem "rswag"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem "lograge"

gem "sidekiq", '~> 6.2.1'
gem "sidekiq-cron"
gem 'redis-rails'
gem 'redis'
gem 'hiredis'
gem 'redis-namespace'

gem "browser" # This gem is used for grabbing browser details

gem 'figaro'

gem 'language_filter' #block offensive words

gem 'ruby-kafka'

gem 'grape', '>= 0.10.0'

gem 'api-pagination'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'mocha'
  gem 'webmock'
  gem 'rspec-rails'
  gem 'rswag-specs'
end

group :development do
  # deployment
  gem "capistrano", "~> 3.11", require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-sidekiq'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
