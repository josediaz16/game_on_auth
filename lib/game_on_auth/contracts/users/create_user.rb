module GameOnAuth
  module Contracts
    module Users
      class CreateUser < Dry::Validation::Contract
        GENDERS = %w[male female].freeze

        params do
          required(:first_name).filled(:string)
          required(:last_name).filled(:string)
          required(:account_id).filled(:integer)
          optional(:gender).value(included_in?: GENDERS)
          optional(:age).value(type?: Integer)
        end
      end
    end
  end
end
