module GameOnAuth
  module Web
    class Router < Roda
      include Dry::Monads[:result]

      plugin :common_logger, GameOnAuth::Application.logger
      plugin :sessions, secret: ENV['SESSION_SECRET']
      plugin :request_headers

      plugin :rodauth, json: :only do
        enable :json, :login, :logout, :create_account, :verify_account, :change_password

        require_login_confirmation? false

        change_password_requires_password? true
        change_password_route 'users/change_password'
        new_password_param 'new_password'

        password_confirm_param 'password_confirmation'

        base_url ENV['API_ROOT']

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
