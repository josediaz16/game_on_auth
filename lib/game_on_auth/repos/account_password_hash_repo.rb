module GameOnAuth
  module Repos
    class AccountPasswordHashRepo < ROM::Repository[:account_password_hashes]
      include Import['container']

      struct_namespace GameOnAuth
      commands :create

      def all
        account_password_hashes.to_a
      end
    end
  end
end
