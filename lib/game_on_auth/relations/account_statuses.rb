module GameOnAuth
  module Relations
    class AccountStatuses < ROM::Relation[:sql]
      schema(:account_statuses, infer: true)
    end
  end
end
