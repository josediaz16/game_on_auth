module GameOnAuth
  module Relations
    class Accounts < ROM::Relation[:sql]
      schema(:accounts, infer: true) do
        associations do
          has_one :user
        end
      end
    end
  end
end
