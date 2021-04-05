module GameOnAuth
  module Relations
    class Users < ROM::Relation[:sql]
      schema(:users, infer: true) do
        associations do
          belongs_to :account
        end
      end

      def with_accounts
        combine(:account)
      end
    end
  end
end
