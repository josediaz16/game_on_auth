require 'spec_helper'

RSpec.describe GameOnAuth::Contracts::Users::CreateUser do
  let(:input) do
    {
      first_name: 'John',
      last_name: 'Doe',
      account_id: 1,
      gender: 'male',
      age: 25
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

  context 'invalid account_id' do
    let(:input) { super().merge(account_id: nil) }

    it 'is failure' do
      expect(result).to be_failure
      expect(result.errors[:account_id]).to include('must be filled')
    end
  end

  context 'invalid gender' do
    let(:input) { super().merge(gender: 'dog') }

    it 'is failure' do
      expect(result).to be_failure
      expect(result.errors[:gender]).to include('must be one of: male, female')
    end
  end

  context 'invalid age' do
    let(:input) { super().merge(age: 'ten') }

    it 'is failure' do
      expect(result).to be_failure
      expect(result.errors[:age]).to include('must be Integer')
    end
  end
end
