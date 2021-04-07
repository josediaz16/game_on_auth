Factory.define(:account) do |f|
  f.email { fake(:internet, :email) }
  f.status_id { 2 }
  f.association(:account_password_hashes, count: 1)
end
