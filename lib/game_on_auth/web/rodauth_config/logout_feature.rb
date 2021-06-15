module GameOnAuth
  module Web
    module RodauthConfig
      module LogoutFeature
        include Dry::Monads[:result]

        def self.call(rodauth)
          rodauth.instance_eval do
            logout_route 'users/sign_out'

            after_logout do
              token = request.headers['Authorization']
              logout_user = GameOnAuth::Transactions::Users::LogoutUser.new

              case logout_user.call(token: token)
              in Success
                response['Authorization'] = nil
              in Failure(some)
                response.status = 422
                set_field_error(:errors, { login: 'Unable to destroy session' })
              end
            end
          end

        end
      end
    end
  end
end
