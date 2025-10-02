require 'rails_helper'

RSpec.describe User, type: :model do
  let (:unconfirmed_user) { FactoryBot.create(:unconfirmed_user) }
  describe 'User' do
    context 'confirmation by email' do
      it 'return true confirmed status' do
        confirmation_status = ::User.confirm_by_token(unconfirmed_user.confirmation_token).confirmed?
        expect(confirmation_status).to eq(true)
      end
    end
  end
end
