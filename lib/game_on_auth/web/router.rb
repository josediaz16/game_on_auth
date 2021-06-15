module GameOnAuth
  module Web
    class Router < Roda
      include Dry::Monads[:result]

      plugin :common_logger, GameOnAuth::Application.logger
      plugin :sessions, secret: ENV['SESSION_SECRET']

      plugin :rodauth, json: :only do
        enable :json, :login, :logout, :create_account, :verify_account

        require_login_confirmation? false
        password_confirm_param 'password_confirmation'
        base_url 'http://localhost:3000'

        RodauthConfig::JsonFeature.call(self)
        RodauthConfig::LogoutFeature.call(self)
        RodauthConfig::LoginFeature.call(self)
        RodauthConfig::CreateAccountFeature.call(self)
        RodauthConfig::VerifyAccountFeature.call(self)
      end

      route do |r|
        r.rodauth
      end
    end
  end
end
