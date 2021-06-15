module GameOnAuth
  module Web
    module RodauthConfig
      module CreateAccountFeature
        include Dry::Monads[:result]

        def self.call(rodauth)
          rodauth.instance_eval do
            create_account_route 'users/sign_up'

            before_create_account do
              validate_user_contract = GameOnAuth::Contracts::Users::CreateUser.new

              input = request.params.to_h
              result = validate_user_contract.call(input)

              if result.failure?
                response.status = 422
                set_field_error(:errors, result.errors.to_h)
              end
            end

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
end
