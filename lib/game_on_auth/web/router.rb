module GameOnAuth
  module Web
    class Router < Roda
      include Dry::Monads[:result]

      plugin :common_logger, GameOnAuth::Application.logger
      plugin :sessions, secret: ENV['SESSION_SECRET']
      plugin :request_headers

      plugin :rodauth, json: :only do
        enable :change_password,
          :change_password_notify,
          :create_account,
          :json,
          :login,
          :logout,
          :verify_account

        require_login_confirmation? false
        password_confirm_param 'password_confirmation'
        base_url ENV['API_ROOT']

        RodauthConfig::ChangePasswordFeature.call(self)
        RodauthConfig::CreateAccountFeature.call(self)
        RodauthConfig::JsonFeature.call(self)
        RodauthConfig::LoginFeature.call(self)
        RodauthConfig::LogoutFeature.call(self)
        RodauthConfig::VerifyAccountFeature.call(self)
      end

      route do |r|
        r.rodauth
      end
    end
  end
end
