require 'web_helper'

RSpec.describe '/users', type: :request do
  let(:input) do
    {
      login: 'johndoe@mail.com',
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
