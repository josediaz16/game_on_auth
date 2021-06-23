module GameOnAuth
  module Web
    module RodauthConfig
      module ChangePasswordFeature
        def self.call(rodauth)
          rodauth.instance_eval do
            change_password_requires_password? true
            change_password_route 'users/change_password'
            new_password_param 'new_password'

            password_changed_email_body do
              'Your password has been changed successfully. If you did not perform this action please contact us'
            end
          end
        end
      end
    end
  end
end
