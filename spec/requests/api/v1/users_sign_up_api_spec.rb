require 'rails_helper'

RSpec.describe 'V1::Users::SignUpApi', type: :request do
  let (:existing_user) { FactoryBot.create(:confirmed_user) }
  let (:unconfirmed_user) { FactoryBot.build(:unconfirmed_user) }
  let (:signup_url) { '/api/v1/user/sign_up' }
  context 'When creating a new user' do
    before do
      post signup_url, params: {
        user: {
          email: unconfirmed_user.email,
          password: unconfirmed_user.password,
          password_confirmation: unconfirmed_user.password_confirmation
        }
      }
    end

    it 'returns 201' do
      expect(response.status).to eq(201)
    end

    it 'returns a token' do
      expect(res_json_body['user']['token']).to be_present
    end

    it 'returns the user email' do
      expect(res_json_body['user']['email']).to eq(unconfirmed_user.email)
    end
  end

  context 'When an email already exists' do
    before do
      post signup_url, params: {
        user: {
          email: existing_user.email,
          password: unconfirmed_user.password,
          password_confirmation: unconfirmed_user.password_confirmation
        }
      }
    end

    it 'returns 422' do
      puts "response"
      expect(response.status).to eq(422)
    end
  end
end
