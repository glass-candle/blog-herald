# frozen_string_literal: true

source 'https://rubygems.org'

# Config
gem 'dotenv'
gem 'rake', '~> 13.0'
gem 'zeitwerk', '~> 2.4'

# Utils
gem 'dry-monads', '~> 1.3'
gem 'dry-struct', '~> 1.0'
gem 'dry-system', '~> 0.21'
gem 'dry-transformer', '~> 0.1'
gem 'dry-types', '~> 1.2'
gem 'dry-validation', '~> 1.6'
gem 'nokogiri', '~> 1.12'
gem 'oj', '~> 3.13'

# Infrastructure
gem 'semantic_logger', '~> 4.8'
gem 'sentry-ruby', '~> 4.7'
gem 'telegram-bot-ruby', '~> 0.16'
gem 'typhoeus', '~> 1.4'

# Persistence
gem 'hiredis', '~> 0.6'
gem 'pg', '~> 1.2.3'
gem 'redis', '~> 4.2'
gem 'rom', '~> 5.2'
gem 'rom-sql', '~> 3.5'
gem 'sequel', '~> 5.51'
gem 'sequel_pg', '~> 1.14', require: 'sequel'

group :development do
  gem 'pry'
  gem 'rubocop', '~> 1.20'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
end

group :test do
  gem 'rspec', '~> 3.0'
  gem 'simplecov', '~> 0.21'
  gem 'webmock', '~> 3.13'

  gem 'database_cleaner-sequel', '~> 2.0'
  gem 'rom-factory', '~> 0.10'
end
