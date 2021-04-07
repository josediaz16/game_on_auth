Factory.define(:account_password_hash) do |f|
  #f.association(:account)
  f.password_hash { BCrypt::Password.create('secret', cost: BCrypt::Engine::MIN_COST).to_s }
end
