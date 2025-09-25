require 'rails_helper'

RSpec.describe 'V1::Users::SignInApi', type: :request do
  let (:signin_url) { '/api/v1/user/sign_in' }
  let (:confirmed_user) { FactoryBot.create(:confirmed_user) }
  let (:unconfirmed_user) { FactoryBot.create(:unconfirmed_user) }
  describe 'When signing' do
    context 'with confirmed email it' do
      before do
        post signin_url, params: {
          user: {
            email: confirmed_user.email,
            password: confirmed_user.password
          }
        }
      end
      it 'returns a token' do
        expect(res_json_body['user']['token']).to be_present
      end

      it 'returns 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'with unconfirmed email it' do
       before do
        post signin_url, params: {
          user: {
            email: unconfirmed_user.email,
            password: unconfirmed_user.password
          }
        }
        it 'returns 403' do
        expect(response.status).to eq(403)
      end
      end
    end
  end

  context 'When password is missing' do
    before do
      post signin_url, params: {
        user: {
          email: confirmed_user.email,
          password: ''
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end
end
