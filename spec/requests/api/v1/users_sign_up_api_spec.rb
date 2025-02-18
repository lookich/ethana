require 'rails_helper'

RSpec.describe 'V1::Users::SignUpApi', type: :request do
  let (:user) { build_user }
  let (:existing_user) { create_user }
  let (:signup_url) { '/api/v1/user/sign_up' }
  context 'When creating a new user' do
    before do
      post signup_url, params: {
        email: user.email,
        password: user.password
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(201)
    end

    it 'returns a token' do
      expect(res_json_body['token']).to be_present
    end

    it 'returns the user email' do
      expect(res_json_body['email']).to eq(user.email)
    end
  end

  context 'When an email already exists' do
    before do
      post signup_url, params: {
        email: existing_user.email,
        password: existing_user.password
      }
    end

    it 'returns 400' do
      expect(response.status).to eq(422)
    end
  end
end
