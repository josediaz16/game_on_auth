RSpec.shared_context 'Authentication prerequisites' do
  let!(:account_status_repo) { GameOnAuth::Repos::AccountStatusRepo.new }

  let(:account) { Factory[:account, email: 'michale.baumbach@klocko.org'] }
  let(:user) { Factory[:user, account: account] }
  let(:auth_header) { last_response.headers['Authorization'] }

  before do
    account_status_repo.create({ id: 1, name: 'Unverified' })
    account_status_repo.create({ id: 2, name: 'Verified' })
    account_status_repo.create({ id: 3, name: 'Closed' })
  end

  def login(user, password: 'secret')
    input = {
      login: user.account.email,
      password: password,
    }
    post_json '/users/sign_in', input
  end
end
