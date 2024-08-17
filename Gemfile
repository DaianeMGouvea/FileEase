# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'bootsnap', require: false
gem 'carrierwave'
gem 'devise'

gem 'axlsx'
gem 'axlsx_rails'
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.8', '>= 7.0.8.4'
gem 'redis', '~> 4.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'annotate'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 5.0'
  gem 'rubocop', require: false

  gem 'rubocop-rails', require: false
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'factory_bot_rails', '~> 6.0'
  gem 'faker', '~> 2.0'
  gem 'rails-controller-testing'
  gem 'rspec-sidekiq'
  gem 'simplecov', require: false
end

gem 'dockerfile-rails', '>= 1.6', group: :development

gem 'sidekiq', '~> 7.3'
