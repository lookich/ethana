require 'rails_helper'

RSpec.describe 'V1::Users::SignInApi', type: :request do
  let (:user) { create_user }
  let (:signin_url) { '/api/v1/user/sign_in' }
  context 'When signing in' do
    before do
      post signin_url, params: {
        email: user.email,
        password: user.password
      }
    end

    it 'returns a token' do
      expect(res_json_body['token']).to be_present
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end
  end

  context 'When password is missing' do
    before do
      post signin_url, params: {
        email: user.email,
        password: nil
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end
end
