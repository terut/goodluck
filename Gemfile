source 'https://rubygems.org'

gem 'rails', '4.1.4'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer',  platforms: :ruby
gem 'jbuilder', '~> 2.0'
gem 'bcrypt', '~> 3.1.7'
gem 'haml-rails'

group :development do
  gem 'spring'
end

group :develoment, :test do
  # Use debugger
  # gem 'debugger', group: [:development, :test]
  gem 'pry'
  gem 'rspec-rails'
  gem 'thin'
  gem 'sqlite3'
end

group :production do
  gem 'unicorn'
  gem 'pg'
  gem 'rails_12factor'
end

#gem 'sass-rails', '~> 4.0.3'
#gem 'jquery-rails'
#gem 'turbolinks'
#gem 'sdoc', '~> 0.4.0',          group: :doc
#Use Capistrano for deployment
#gem 'capistrano-rails', group: :development
