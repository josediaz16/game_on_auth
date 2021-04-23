ENV['APP_ENV'] ||= 'development'

require 'bundler'
Bundler.setup(:default, ENV['APP_ENV'])

require 'dotenv'
Dotenv.overload('.env', ".env.#{ENV['APP_ENV']}")
