require_relative 'boot'

require 'dry/system/container'
require 'dry/system/loader/autoloading'
#require 'dry/auto_inject'
require 'zeitwerk'

module GameOnAuth
  class Application < Dry::System::Container
    use :logging
    use :env, inferrer: -> { ENV.fetch('APP_ENV', :development).to_sym }

    configure do |config|
      config.root = File.expand_path('..', __dir__)

      config.component_dirs.auto_register = true
      config.component_dirs.add_to_load_path = false
      config.component_dirs.loader = Dry::System::Loader::Autoloading

      config.component_dirs.add 'lib' do |dir|
        dir.default_namespace = 'game_on_auth'
      end
    end
  end

  Import = Application.injector
end

loader = Zeitwerk::Loader.new
loader.push_dir GameOnAuth::Application.config.root.join('lib').realpath
loader.setup
