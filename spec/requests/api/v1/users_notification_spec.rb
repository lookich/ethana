require 'rails_helper'

RSpec.describe 'V1::Users::SignInApi', type: :request do
  # let (:confirmed_user) { FactoryBot.create(:confirmed_user) }
  let (:notification) { FactoryBot.create(:notification) }


  describe 'When signing' do
    before do
      sign_in(notification.user)
    end
    context 'get user notifications' do
      let (:user_notifications_url) { '/api/v1/user/notifications' }
      it 'count equal to 1' do
        get user_notifications_url, headers: authenticated_headers(request, @auth_token)
        expect(res_json_body['notifications'].count).to eq(1)
      end
    end

    context 'update user notification' do
      let (:user_notification_url) { "/api/v1/user/notifications/#{notification.id}" }
      it 'status return 200' do
        notification.viewed = true
        put user_notification_url, params: { notification: notification.as_json }, headers: authenticated_headers(request, @auth_token)
        expect(response.status).to eq(200)
      end
    end
  end
end
