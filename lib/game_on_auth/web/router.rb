require 'byebug'

module GameOnAuth
  module Web
    class Router < Roda
      include Dry::Monads[:result]

      plugin :common_logger, GameOnAuth::Application.logger
      plugin :sessions, secret: ENV['SESSION_SECRET']

      plugin :rodauth, json: :only do
        RodauthConfig.configure(self)
      end

      route do |r|
        r.rodauth
      end
    end
  end
end
