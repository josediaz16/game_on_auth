module GameOnAuth
  module Web
    class Router < Roda
      include Import['transactions.users.create_user']
      include Dry::Monads[:result]

      plugin :json_parser
      plugin :json
      plugin :common_logger, GameOnAuth::Application.logger
      plugin :sessions, secret: 'my-pinshe-secret-my-pinshe-secret-my-pinshe-secret-my-pinshe-secret-my-pinshe-secret-my-pinshe-secret'

      plugin :rodauth, json: :only do
        enable :login, :logout, :create_account

        #create_account_route '/users'
      end

      route do |r|
        r.rodauth
        #r.post 'users' do
        #  case create_user.call(r.params.to_h)
        #  in Success(result)
        #    result.to_h
        #  in Failure(result)
        #    response.status = 422
        #    { errors: result.errors.to_h }
        #  end
        #end
      end
    end
  end
end
