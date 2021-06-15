require 'web_helper'

RSpec.describe '/users', type: :request do
  around do |example|
    VCR.use_cassette('kong_logout') do
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

  describe 'POST /sign_out' do
    context 'jwt token is ok' do
      it 'returns 200' do
        post_json '/users/sign_in', input

        auth_header = last_response.headers['Authorization']

        post_json '/users/sign_out', {}, headers: { 'HTTP_AUTHORIZATION' => auth_header }
        expect(last_response.status).to eq(200)
        expect(last_response.headers['Authorization']).to eq(nil)
      end
    end
  end
end
