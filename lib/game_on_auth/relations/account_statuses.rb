module GameOnAuth
  module Relations
    class AccountStatuses < ROM::Relation[:sql]
      schema(:account_statuses, infer: true) do
        associations do
          has_many :accounts
        end
      end
    end
  end
end
