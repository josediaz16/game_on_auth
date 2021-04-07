Factory.define(:user, struct_namespace: GameOnAuth) do |f|
  f.first_name { fake(:name, :first_name) }
  f.last_name  { fake(:name, :last_name) }
  f.age        { 20 }
  f.gender     { fake(:gender, :binary_type) }

  f.association(:account)
  f.timestamps
end
