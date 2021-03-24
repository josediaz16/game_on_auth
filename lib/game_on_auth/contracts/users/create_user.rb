module GameOnAuth
  module Contracts
    module Users
      class CreateUser < Dry::Validation::Contract
        params do
          required(:first_name).filled(:string)
          required(:last_name).filled(:string)
          required(:email).filled(:string)
        end
      end
    end
  end
end
