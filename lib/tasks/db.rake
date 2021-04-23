require 'dotenv/tasks'
require 'byebug'

namespace :db do
  task :create do
    database_url = ENV['DATABASE_URL']
    database_connection_parts = database_url.match(/(postgresql:\/\/(\w+)@(\w+):(\d+))\/(\w+)/)

    raise ArgumentError, 'Invalid database url' if database_connection_parts.nil?
    _url, url_without_db, *connection_details = database_connection_parts.to_a
    db_name = connection_details.last

    Sequel.connect("#{url_without_db}/postgres") do |db|
      db.execute("DROP DATABASE IF EXISTS #{db_name}")
      db.execute("CREATE DATABASE #{db_name}")
    end

    Sequel.connect(_url) do |db|
      db.execute("CREATE EXTENSION citext")
    end

    puts "Created database #{db_name}"
  end

  namespace :test do
    task :prepare do
      system('APP_ENV=test rake db:create')
      system('APP_ENV=test rake db:migrate')
    end
  end
end
