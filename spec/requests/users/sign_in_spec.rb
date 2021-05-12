require 'web_helper'

RSpec.describe '/users', type: :request do
  around do |example|
    VCR.use_cassette('kong_login') do
      example.run
    end
  end

  let(:input) do
    {
      login: user.account.email,
      password: 'secret',
    }
  end

  let(:account) { Factory[:account, email: 'michale.baumbach@klocko.org'] }
  let(:user) { Factory[:user, account: account] }

  describe 'POST /sign_in' do
    context 'with valid credentials' do
      it 'returns 200' do
        post_json '/users/sign_in', input
        expect(last_response.status).to eq(200)

        auth_header = last_response.headers['Authorization']
        expect(auth_header).not_to eq(nil)

        decoded_jwt = JWT.decode(auth_header, ENV['SESSION_SECRET'], { algorithm: 'HS256' })
        expect(decoded_jwt[0]).to include({
          'email' => input[:login],
          'id' => a_kind_of(String),
          'authenticated_by' => 'password'
        })
      end
    end

    context 'invalid email' do
      let(:input) { super().merge({ login: 'whatever@mail.com' }) }

      it 'returns 401' do
        post_json '/users/sign_in', input
        expect(last_response.status).to eq(401)

        expect(parsed_body['errors']['login']).to include('No matching login')
      end
    end

    context 'invalid password' do
      let(:input) { super().merge({ password: 'yabadabadu' }) }

      it 'returns 401' do
        post_json '/users/sign_in', input
        expect(last_response.status).to eq(401)

        expect(parsed_body['errors']['login']).to include('No matching login')
      end
    end
  end
end
