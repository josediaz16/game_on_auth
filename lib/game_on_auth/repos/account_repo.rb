module GameOnAuth
  module Repos
    class AccountRepo < ROM::Repository[:accounts]
      include Import['container']

      struct_namespace GameOnAuth
      commands :create

      def all
        accounts.to_a
      end

      def by_email(email)
        accounts
          .where(email: email)
          .combine(:users)
          .one
      end
    end
  end
end
