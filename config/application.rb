require_relative 'boot'

require 'dry/system/container'
require 'dry/auto_inject'

module GameOnAuth
  class Application < Dry::System::Container
    use :logging
    use :env, inferrer: -> { ENV.fetch('APP_ENV', :development).to_sym }

    configure do |config|
      config.root = File.expand_path('..', __dir__)
      config.default_namespace = 'game_on_auth'

      config.auto_register = 'lib'
    end

    load_paths!('lib')
  end

  Import = Dry::AutoInject(Application)
end
