module GameOnAuth
  module Web
    module RodauthConfig
      module LoginFeature
        include Dry::Monads[:result]

        def self.call(rodauth)
          rodauth.instance_eval do
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
          end

        end
      end
    end
  end
end
