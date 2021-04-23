require_relative 'config/application'

require 'rom-sql'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    GameOnAuth::Application.start(:db)
    config = GameOnAuth::Application['db.config']
    config.gateways[:default].use_logger(Logger.new($stdout))
  end
end

Dir["#{File.dirname(__FILE__)}/lib/tasks/*.rake" ].each{ |rake_file| load rake_file }
