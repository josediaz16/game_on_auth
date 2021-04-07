module GameOnAuth
  module Relations
    class AccountPasswordHashes < ROM::Relation[:sql]
      schema(:account_password_hashes, infer: true) do
        associations do
          belongs_to :account
        end
      end
    end
  end
end
