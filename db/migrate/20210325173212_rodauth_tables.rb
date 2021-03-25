# frozen_string_literal: true
require 'rodauth/migrations'

ROM::SQL.migration do
  up do
    extension :date_arithmetic

    create_table(:account_statuses) do
      primary_key :id, type: Integer
      column :name, String, null: false, unique: true
    end

    from(:account_statuses)
      .import([:id, :name], [[1, 'Unverified'], [2, 'Verified'], [3, 'Closed']])

    db = self

    create_table(:accounts) do
      primary_key :id, type: Bignum
      foreign_key :status_id, :account_statuses, null: false, default: 1

      citext :email, null: false
      constraint :valid_email, email: /^[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+$/
      index :email, unique: true, where: { status_id: [1, 2] }
    end

    deadline_opts = proc do |days|
      { null: false, default: Sequel.date_add(Sequel::CURRENT_TIMESTAMP, days: days) }
    end

    create_table(:account_authentication_audit_logs) do
      primary_key :id, type: Bignum
      foreign_key :account_id, :accounts, null: false, type: Bignum

      column :at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :message, String, null: false
      column :metadata, :jsonb

      index [:account_id, :at], name: :audit_account_at_idx
      index :at, name: :audit_at_idx
    end

    create_table(:account_password_reset_keys) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      column :key, String, null: false
      column :deadline, DateTime, deadline_opts[1]
      column :email_last_sent, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    create_table(:account_jwt_refresh_keys) do
      primary_key :id, type: :Bignum
      foreign_key :account_id, :accounts, null: false, type: :Bignum

      column :key, String, null: false
      column :deadline, DateTime, deadline_opts[1]
      index :account_id, name: :account_jwt_rk_account_id_idx
    end

    create_table(:account_verification_keys) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum

      column :key, String, null: false
      column :requested_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :email_last_sent, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    # Used by the verify login change feature
    create_table(:account_login_change_keys) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      column :key, String, null: false
      column :login, String, null: false
      column :deadline, DateTime, deadline_opts[1]
    end

    # Used by the remember me feature
    create_table(:account_remember_keys) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      column :key, String, null: false
      column :deadline, DateTime, deadline_opts[14]
    end

    # Used by the lockout feature
    create_table(:account_login_failures) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      column :number, Integer, null: false, default: 1
    end
    create_table(:account_lockouts) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      column :key, String, null: false
      column :deadline, DateTime, deadline_opts[1]
      column :email_last_sent, DateTime
    end

    # Used by the email auth feature
    create_table(:account_email_auth_keys) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      column :key, String, null: false
      column :deadline, DateTime, deadline_opts[1]
      column :email_last_sent, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    # Used by the password expiration feature
    create_table(:account_password_change_times) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      column :changed_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    create_table(:account_active_session_keys) do
      foreign_key :account_id, :accounts, type: :Bignum
      column :session_id, String
      column :created_at, Time, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :last_use, Time, null: false, default: Sequel::CURRENT_TIMESTAMP
      primary_key [:account_id, :session_id]
    end

    # Used by the otp feature
    create_table(:account_otp_keys) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      column :key, String, null: false
      column :num_failures, Integer, null: false, default: 0
      column :last_use, Time, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    # Used by the recovery codes feature
    create_table(:account_recovery_codes) do
      foreign_key :id, :accounts, type: :Bignum
      column :code, String
      primary_key [:id, :code]
    end

    # Used by the sms codes feature
    create_table(:account_sms_codes) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      column :phone_number, String, null: false
      column :num_failures, Integer
      column :code, String
      column :code_issued_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    create_table(:account_password_hashes) do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      column :password_hash, String, null: false
    end
    Rodauth.create_database_authentication_functions(self)

    create_table(:account_previous_password_hashes) do
      primary_key :id, type: :Bignum
      foreign_key :account_id, :accounts, type: :Bignum
      column :password_hash, String, null: false
    end
    Rodauth.create_database_previous_password_check_functions(self)
  end

  down do
    drop_table(
      :account_sms_codes,
      :account_recovery_codes,
      :account_otp_keys,
      :account_active_session_keys,
      :account_password_change_times,
      :account_email_auth_keys,
      :account_lockouts,
      :account_login_failures,
      :account_remember_keys,
      :account_login_change_keys,
      :account_verification_keys,
      :account_jwt_refresh_keys,
      :account_password_reset_keys,
      :account_authentication_audit_logs,
      :accounts,
      :account_statuses,
      :account_previous_password_hashes,
      :account_password_hashes
    )
    Rodauth.drop_database_previous_password_check_functions(self)
    Rodauth.drop_database_authentication_functions(self)
  end
end
