require 'byebug'

module GameOnAuth
  module Web
    module RodauthConfig
      module VerifyAccountFeature
        include Dry::Monads[:result]

        def self.call(rodauth)
          rodauth.instance_eval do
            verify_account_email_subject 'Please verify your account'

            send_verify_account_email do
              if response.status != 422
                send_email(create_verify_account_email)
              end
            end

            verify_account_email_body do
              "The user #{account[login_column]} has created an account. Click here to approve it: #{verify_account_email_link}."
            end
          end
        end
      end
    end
  end
end
