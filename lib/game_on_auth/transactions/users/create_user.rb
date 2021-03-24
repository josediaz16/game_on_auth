module GameOnAuth
  module Transactions
    module Users
      class CreateUser
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:call)

        include Import['contracts.users.create_user', 'repos.user_repo']

        def call(input)
          values = yield validate(input)
          user = yield persist(values)

          Success(user)
        end

        private

        def validate(input)
          create_user.call(input).to_monad
        end

        def persist(result)
          Success(user_repo.create(result.values))
        end
      end
    end
  end
end
