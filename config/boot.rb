# frozen_string_literal: true

ENV['APP_ENV'] ||= ENV['RACK_ENV'] || 'development'

require 'bundler'
Bundler.setup(:default, ENV['APP_ENV'])

require 'dotenv/load'
