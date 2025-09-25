require 'rails_helper'

RSpec.describe 'V1::Users::SignOutApi', type: :request do
  let (:confirmed_user) { FactoryBot.create(:confirmed_user) }
  let (:signout_url) { '/api/v1/user/sign_out' }
  describe 'When signing out' do
    before do
      sign_in(confirmed_user)
    end

    context 'with a correct authorization header' do
      it 'returns 200' do
        post signout_url, headers: authenticated_headers(request, @auth_token)
        expect(response.status).to eq(200)
      end

      it 'delete token' do
        user_jwts_before = confirmed_user.allowlisted_jwts.count
        post signout_url, headers: authenticated_headers(request, @auth_token)
        expect(user_jwts_before).to be > confirmed_user.allowlisted_jwts.count
      end
    end

    context 'with a wrong authorization header' do
      it 'returns 401' do
        wrong_token = SecureRandom.hex(32)
        post signout_url, headers: authenticated_headers(request, wrong_token)
        expect(response.status).to eq(401)
      end
    end
  end
end
