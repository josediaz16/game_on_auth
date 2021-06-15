require 'spec_helper'

RSpec.describe GameOnAuth::Repos::UserRepo, with_accounts: true do
  let(:account) { Factory[:account, email: 'michale.baumbach@klocko.org'] }

  describe '#create' do
    it 'creates a user' do
      user = subject.create({
        first_name: 'John',
        last_name: 'Doe',
        account_id: account.id
      })

      expect(user).to be_a(GameOnAuth::User)
      expect(user.id).not_to be_nil
      expect(user.first_name).to eq('John')
      expect(user.last_name).to eq('Doe')
      expect(user.account_id).to eq(account.id)
      expect(user.created_at).not_to be_nil
      expect(user.updated_at).not_to be_nil
    end
  end

  describe '#all' do
    let!(:user) { subject.create({ first_name: 'John', last_name: 'Doe', account_id: account.id }) }

    it 'returns all users' do
      users = subject.all
      expect(users.count).to eq(1)
      expect(users.first).to be_a(GameOnAuth::User)
    end
  end
end
