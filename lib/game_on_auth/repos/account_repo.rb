module GameOnAuth
  module Repos
    class AccountRepo < ROM::Repository[:accounts]
      include Import['container']

      struct_namespace GameOnAuth
      commands :create

      def all
        accounts.to_a
      end
    end
  end
end
