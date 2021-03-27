# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :users do
      primary_key :id
      foreign_key :account_id, :accounts, null: false

      column :first_name, String, null: false
      column :last_name, String, null: false
      column :age, Integer
      column :gender, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
