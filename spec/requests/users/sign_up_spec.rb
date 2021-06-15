require 'web_helper'

RSpec.describe '/users', type: :request do
  around do |example|
    VCR.use_cassette('kong_login') do
      example.run
    end
  end

  let(:input) do
    {
      login: 'michale.baumbach@klocko.org',
      password: 'lkfasjdflkasd',
      password_confirmation: 'lkfasjdflkasd',
      first_name: 'John',
      last_name: 'Doe'
    }
  end

  let(:accounts_repo) { GameOnAuth::Repos::AccountRepo.new }

  describe 'POST /sign_up' do
    context 'with valid input' do
      it 'returns 200' do
        post_json '/users/sign_up', input
        expect(last_response.status).to eq(200)

        user = parsed_body
        expect(user['id']).not_to be_nil
        expect(user['account_id']).not_to be_nil
        expect(user['first_name']).to eq('John')
        expect(user['last_name']).to eq('Doe')

        expect(accounts_repo.all.count).to eq(1)

        account = accounts_repo
          .accounts
          .combine(:account_status)
          .one

        expect(account.account_status.name).to eq('Unverified')
      end
    end

    context 'verify account' do
      it 'returns 200' do
        post_json '/users/sign_up', input
        expect(last_response.status).to eq(200)

        urls = URI.extract(Mail::TestMailer.deliveries.first.body.to_s, ['http'])
        params = Addressable::URI.parse(urls.first).query_values
        key = params['key'].gsub(/\./, '')

        post_json "/users/verify?key=#{key}", input

        account = accounts_repo
          .accounts
          .combine(:account_status)
          .one

        expect(account.account_status.name).to eq('Verified')

        auth_header = last_response.headers['Authorization']
        expect(auth_header).not_to eq(nil)
      end
    end

    context 'invalid input' do
      let(:input) { super().merge({ first_name: nil }) }

      it 'returns 422' do
        post_json '/users/sign_up', input
        expect(last_response.status).to eq(422)

        expect(parsed_body['errors']['first_name']).to include('must be filled')
        expect(accounts_repo.all.count).to eq(0)
      end
    end
  end
end
