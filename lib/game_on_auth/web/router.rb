require 'byebug'

module GameOnAuth
  module Web
    class Router < Roda
      include Dry::Monads[:result]

      plugin :common_logger, GameOnAuth::Application.logger
      plugin :sessions, secret: 'my-pinshe-secret-my-pinshe-secret-my-pinshe-secret-my-pinshe-secret-my-pinshe-secret-my-pinshe-secret'

      plugin :rodauth, json: :only do
        enable :json, :login, :logout, :create_account

        require_login_confirmation? false
        password_confirm_param 'password_confirmation'
        json_response_field_error_key 'field_error'

        after_create_account do
          create_user = GameOnAuth::Transactions::Users::CreateUser.new
          input = request
            .params
            .to_h
            .merge({ account_id: account_id })

          case create_user.call(input)
          in Success(result)
            @user = result.to_h
          in Failure(result)
            response.status = 422
            throw_error(:errors, result.errors.to_h)
          end
        end

        json_response_body do |body|
          json_body = body.transform_keys(&:to_sym)

          case json_body
          in field_error: [:errors, errors]
            { errors: errors }.to_json
          in success: _message
            @user.to_json
          end
        end
      end

      route do |r|
        r.rodauth
      end
    end
  end
end
