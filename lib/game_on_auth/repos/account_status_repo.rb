module GameOnAuth
  module Repos
    class AccountStatusRepo < ROM::Repository[:account_statuses]
      include Import['container']

      struct_namespace GameOnAuth

      commands :create

      def all
        account_statuses.to_a
      end
    end
  end
end
