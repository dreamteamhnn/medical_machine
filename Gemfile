source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
gem "rails", "~> 5.1.4"

# Database
gem "mysql2", ">= 0.3.18", "< 0.5"

# Common
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem 'jquery-rails'
gem "turbolinks", "~> 5"
gem "coffee-rails"

# Frontend
gem "font-awesome-rails"
gem "simple_calendar", "~> 2.0"
gem "lodash-rails"
# pagination
gem "kaminari"
gem "bootstrap-kaminari-views"

# Admin
gem "devise"

# Upload file
gem "mini_magick"
gem "carrierwave", "~> 1.0"

# Setting
gem "config"

# Elasticsearch
gem "searchkick", "~> 2.3", ">= 2.3.2"

# Setting evironment variables
gem "dotenv-rails"

# nested attribute
gem "cocoon"

# Ckeditor: format article content with html form
gem "ckeditor"

# Rails server
gem "unicorn", "~> 4.8.3"

# Fake data
gem "faker", git: "git://github.com/stympy/faker.git", branch: "master"

group :development, :test do
  # Debug
  gem "pry-rails"
  gem "pry-byebug"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"

  # speech up rails server and rails console in development env
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  # catch mails
  gem "letter_opener"
  gem "letter_opener_web"

  # capistrano for deploying
  gem "capistrano", "3.4.0"
  # rails specific capistrano functions
  gem "capistrano-rails", "~> 1.1.0"
  # integrate bundler with capistrano
  gem "capistrano-bundler"
  # if you are using Rbenv
  gem "capistrano-rbenv", "~> 2.0"
  # include helper tasks
  gem "capistrano-cookbook", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
