module GameOnAuth
  module Web
    class RodauthConfig
      include Dry::Monads[:result]

      def self.configure(rodauth)
        rodauth.instance_eval do
          enable :json, :login, :logout, :create_account

          # General Config
          require_login_confirmation? false
          password_confirm_param 'password_confirmation'

          # JSON Config
          json_response_field_error_key 'field_error'
          json_response_body do |body|
            json_body = body.transform_keys(&:to_sym)

            case json_body
            in field_error: [:errors, errors]
              { errors: errors }.to_json

            in { field_error: ['login', *] } | { field_error: ['password', *] }
              { errors: { login: 'No matching login' } }.to_json

            in success: _message
              @user.to_json

            else
              json_body.to_json
            end
          end

          # Logout Config
          logout_route 'users/sign_out'

          after_logout do
            token = request.get_header('Authorization')
            logout_user = GameOnAuth::Transactions::Users::LogoutUser.new

            case logout_user.call(token: token)
            in Success
              response['Authorization'] = nil
            in Failure(some)
              response.status = 422
              set_field_error(:errors, { login: 'Unable to destroy session' })
            end
          end

          # Login Config
          login_route 'users/sign_in'

          after_login do
            authenticate_user = GameOnAuth::Transactions::Users::AuthenticateUser.new

            case authenticate_user.call({ email: request.params['login'] })
            in Success(token)
              response['Authorization'] = token
            in Failure(some)
              response.status = 422
              set_field_error(:errors, { login: 'Unable to create session' })
            end
          end


          # Create Account Config
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

        end
      end
    end
  end
end
