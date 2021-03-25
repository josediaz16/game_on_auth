require 'web_helper'

RSpec.describe '/users' do
  let(:input) do
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'johndoe@mail.com'
    }
  end

  describe 'POST /' do
    context 'with valid input' do
      it 'returns 200' do
        post_json '/create-account', input
        expect(last_response.status).to eq(200)

        user = parsed_body
        expect(user['id']).not_to be_nil
        expect(user['first_name']).to eq('John')
        expect(user['last_name']).to eq('Doe')
        expect(user['email']).to eq('johndoe@mail.com')
      end
    end

    context 'invalid input' do
      let(:input) { super().merge({ first_name: nil }) }

      it 'returns 422' do
        post_json '/create-account', input
        expect(last_response.status).to eq(422)

        expect(parsed_body['errors']['first_name']).to include('must be filled')
      end
    end
  end
end
