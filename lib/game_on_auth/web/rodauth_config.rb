module GameOnAuth
  module Web
    class RodauthConfig
      include Dry::Monads[:result]

      def self.configure(rodauth)
        rodauth.instance_eval do
          enable :json, :login, :logout, :create_account

          require_login_confirmation? false
          password_confirm_param 'password_confirmation'
          json_response_field_error_key 'field_error'
          create_account_route 'users/sign_up'

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
              set_field_error(:errors, result.errors.to_h)
              raise Sequel::Rollback
            end
          end

          json_response_body do |body|
            json_body = body.transform_keys(&:to_sym)

            case json_body
            in field_error: [:errors, errors]
              { errors: errors }.to_json
            in success: _message
              @user.to_json
            else
              json_body.to_json
            end
          end

        end
      end
    end
  end
end
