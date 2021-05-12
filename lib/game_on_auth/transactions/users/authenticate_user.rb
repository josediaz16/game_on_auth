require 'faraday'
require 'jwt'

module GameOnAuth
  module Transactions
    module Users
      class AuthenticateUser
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:call)

        def call(input)
          consumer = yield create_consumer(**input)
          jwt_credential = yield create_jwt_credential(consumer)
          jwt_token = yield craft_jwt(email: consumer, **jwt_credential)

          Success(jwt_token)
        rescue Faraday::ConnectionFailed
          Failure(:kong_not_available)
        end

        private

        def create_consumer(email:, **_args)
          body = "username=#{email}"
          response = make_request('http://host.docker.internal:8001/consumers', body)

          case response
          in { name: 'unique constraint violation' } | { id: String, username: ^email  }
            Success(email)
          else
            Failure(:unable_to_create_consumer)
          end
        end

        def create_jwt_credential(consumer)
          url = "http://host.docker.internal:8001/consumers/#{consumer}/jwt"
          response = make_request(url, { secret: ENV['SESSION_SECRET'] })

          case response
          in { key:, secret: }
            Success({ key: key, secret: secret })
          else
            Failure(:unable_to_create_jwt)
          end
        end

        def craft_jwt(email:, key:, secret:)
          payload = {
            iss: key,
            email: email,
            authenticated_by: 'password'
          }

          jwt_token = JWT.encode(payload, secret, 'HS256')
          Success(jwt_token)
        rescue => _error
          Failure(:unable_to_craft_jwt)
        end

        def make_request(url, body = {})
          Faraday
            .post(url, body)
            .then { |http_response| JSON.parse(http_response.body, symbolize_names: true) }
        end
      end
    end
  end
end
