module GameOnAuth
  module Relations
    class Accounts < ROM::Relation[:sql]
      schema(:accounts, infer: true)
    end
  end
end