require 'spec_helper'

RSpec.describe GameOnAuth::Transactions::Users::AuthenticateUser, auth: true do
  around do |example|
    VCR.use_cassette('kong_login', match_requests_on: [:method, :body], record: :new_episodes) do
      example.run
    end
  end

  let(:result) { subject.call(input) }

  let(:input) { { email: 'michale.baumbach@klocko.org'} }

  let(:result) { subject.call(input) }

  describe '#call' do
    context 'kong request is successful' do
      it 'is success and wraps a jwt token' do
        expect(result).to be_success
        expect(result.success).to be_a_kind_of(String)
      end
    end

    context 'kong is not avaiable' do
      let(:input) { { email: 'notavailable@kong.com' } }

      it 'is failure' do
        expect(result).to be_failure
        expect(result.failure).to eq(:kong_not_available)
      end
    end
  end
end
