RSpec.shared_context 'with authenticated user' do
  let(:current_user) { create(:user) }

  before do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, current_user)
    request.headers.merge!(auth_headers)
  end
end
