require 'spec_helper'

RSpec.describe GameOnAuth::Transactions::Users::CreateUser do
  let(:user_repo) { double('UserRepo') }
  let(:user) { GameOnAuth::User.new(id: 1, first_name: 'John') }

  subject { described_class.new(user_repo: user_repo) }

  let(:input) do
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'johndoe@mail.com'
    }
  end

  let(:result) { subject.call(input) }

  describe '#call' do
    context 'valid input' do
      it 'creates a user' do
        expect(user_repo).to receive(:create) { user }
        expect(result).to be_success
        expect(result.success).to eq(user)
      end
    end

    context 'invalid input' do
      let(:input) { super().merge(first_name: nil) }

      it 'does not create a user' do
        expect(user_repo).not_to receive(:create)
        expect(result).to be_failure
        expect(result.failure.errors[:first_name]).to include('must be filled')
      end
    end
  end
end
