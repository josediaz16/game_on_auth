require 'spec_helper'

RSpec.describe GameOnAuth::Repos::UserRepo do
  describe '#create' do
    it 'creates a user' do
      user = subject.create({
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@mail.com'
      })

      expect(user).to be_a(GameOnAuth::User)
      expect(user.id).not_to be_nil
      expect(user.first_name).to eq('John')
      expect(user.last_name).to eq('Doe')
      expect(user.email).to eq('john@mail.com')
      expect(user.created_at).not_to be_nil
      expect(user.updated_at).not_to be_nil
    end
  end

  describe '#all' do
    let!(:user) { subject.create({ first_name: 'John', last_name: 'Doe', email: 'john@mail.com' }) }

    it 'returns all users' do
      users = subject.all
      expect(users.count).to eq(1)
      expect(users.first).to be_a(GameOnAuth::User)
    end
  end
end
