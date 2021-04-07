module GameOnAuth
  module Relations
    class Accounts < ROM::Relation[:sql]
      schema(:accounts, infer: true) do
        associations do
          has_one :user
          has_many :account_password_hashes
        end
      end
    end
  end
end
