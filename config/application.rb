require_relative 'boot'

require 'dry/system/container'

module GameOnAuth
  class Application < Dry::System::Container
    configure do |config|
      config.root = File.expand_path('..', __dir__)
      config.default_namespace = 'game_on_auth'

      config.auto_register = 'lib'
    end

    load_paths!('lib')
  end
end
