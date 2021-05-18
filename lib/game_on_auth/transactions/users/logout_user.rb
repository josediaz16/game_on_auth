require 'faraday'
require 'jwt'

module GameOnAuth
  module Transactions
    module Users
      class LogoutUser
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:call)

        def call(token:)
          token_data = yield uncraft_jwt(token)
          yield delete_credential(**token_data)

          Success(:ok)
        rescue Faraday::ConnectionFailed
          Failure(:kong_not_available)
        end

        private

        def delete_credential(id:, email:)
          url = "http://host.docker.internal:8001/consumers/#{email}/jwt/#{id}"
          response = Faraday.delete(url)

          case response.status
          when 204
            Success(:ok)
          else
            Failure(:unable_to_delete_jwt)
          end
        end

        def uncraft_jwt(token)
          response = JWT.decode(token, ENV['SESSION_SECRET'], { algorithm: 'HS256' }).first
          Success({
            id: response['id'],
            email: response['email']
          })
        rescue => _error
          Failure(:unable_to_uncraft_jwt)
        end
      end
    end
  end
end
