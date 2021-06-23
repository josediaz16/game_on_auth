module GameOnAuth
  module Web
    module RodauthConfig
      module JsonFeature

        def self.call(rodauth)
          rodauth.instance_eval do
            json_response_field_error_key 'field_error'
            json_response_body do |body|
              json_body = body.transform_keys(&:to_sym)

              case json_body
              in field_error: [:errors, errors]
                { errors: errors }.to_json

              in { field_error: ['login', *] } | { field_error: ['password', *] }
                { errors: { login: 'No matching login' } }.to_json

              in field_error: [String => field, String => message]
                { errors: { field => message } }.to_json

              in success: _message
                @user.to_json

              else
                json_body.to_json
              end
            end
          end

        end
      end
    end
  end
end
