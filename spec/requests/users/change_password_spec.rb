require 'web_helper'

RSpec.describe '/users', type: :request do
  around do |example|
    VCR.use_cassette('kong_login') do
      example.run
    end
  end

  describe 'POST /change_password' do
    context 'with valid data' do
      let(:input) do
        {
          password: 'secret',
          new_password: 'new_secret',
          password_confirmation: 'new_secret'
        }
      end

      it 'returns 200' do
        login(user)

        post_json '/users/change_password', input, headers: { 'HTTP_AUTHORIZATION' => auth_header }
        expect(last_response.status).to eq(200)
      end
    end

    context 'with invalid current password' do
      let(:input) do
        {
          password: 'secret_bad',
          new_password: 'new_secret',
          password_confirmation: 'new_secret'
        }
      end

      it 'returns 401' do
        login(user)

        post_json '/users/change_password', input, headers: { 'HTTP_AUTHORIZATION' => auth_header }
        expect(last_response.status).to eq(401)
        expect(parsed_body['errors']['login']).to include('No matching login')
      end
    end

    context 'with invalid new password' do
      let(:input) do
        {
          password: 'secret',
          new_password: 'new_secret',
          password_confirmation: 'new_secret_bad'
        }
      end

      it 'returns 422' do
        login(user)

        post_json '/users/change_password', input, headers: { 'HTTP_AUTHORIZATION' => auth_header }
        expect(last_response.status).to eq(422)
        expect(parsed_body['errors']['new_password']).to include('passwords do not match')
      end
    end

    context 'with empty input' do
      let(:input) { {} }

      it 'returns 422' do
        login(user)

        post_json '/users/change_password', input, headers: { 'HTTP_AUTHORIZATION' => auth_header }
        expect(last_response.status).to eq(401)
        expect(parsed_body['errors']['login']).to include('No matching login')
      end
    end
  end
end
