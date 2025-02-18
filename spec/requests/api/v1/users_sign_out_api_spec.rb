require 'rails_helper'

RSpec.describe 'V1::Users::SignOutApi', type: :request do
  let (:user) { create_user }
  let (:signout_url) { '/api/v1/user/sign_out' }
  let (:signin_url) { '/api/v1/user/sign_in' }
  context 'When signing out' do
    before do
      post signin_url, params: {
        email: user.email,
        password: user.password
      }
      @auth_token = res_json_body['token']
    end

    context 'with a correct authorization header' do
      it 'returns 200' do
        delete signout_url, headers: authenticated_headers(request, @auth_token)
        expect(response.status).to eq(200)
      end

      it 'delete token' do
        user_jwts_before = user.allowlisted_jwts.count
        delete signout_url, headers: authenticated_headers(request, @auth_token)
        expect(user_jwts_before).to be > user.allowlisted_jwts.count
      end
    end

    it 'with a wrong authorization header returns 401' do
      delete signout_url, headers: authenticated_headers(request, @auth_token + '.0')
      expect(response.status).to eq(401)
    end
  end
end
