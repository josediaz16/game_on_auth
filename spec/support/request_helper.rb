RSpec.shared_context 'Authentication prerequisites' do
  let!(:account_status_repo) { GameOnAuth::Repos::AccountStatusRepo.new }

  before do
    account_status_repo.create({ id: 1, name: 'Unverified' })
    account_status_repo.create({ id: 2, name: 'Verified' })
    account_status_repo.create({ id: 3, name: 'Closed' })
  end
end
