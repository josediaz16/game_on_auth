require 'spec_helper'

RSpec.describe GameOnAuth::Contracts::Users::CreateUser do
  let(:input) do
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'johndoe@mail.com'
    }
  end

  let(:result) { subject.call(input) }

  context 'valid data' do
    it 'is success' do
      expect(result).to be_success
    end
  end

  context 'invalid first_name' do
    let(:input) { super().merge(first_name: nil) }

    it 'is failure' do
      expect(result).to be_failure
      expect(result.errors[:first_name]).to include('must be filled')
    end
  end

  context 'invalid last_name' do
    let(:input) { super().merge(last_name: nil) }

    it 'is failure' do
      expect(result).to be_failure
      expect(result.errors[:last_name]).to include('must be filled')
    end
  end

  context 'invalid email' do
    let(:input) { super().merge(email: nil) }

    it 'is failure' do
      expect(result).to be_failure
      expect(result.errors[:email]).to include('must be filled')
    end
  end
end
