require 'faker'
require 'factory_bot'

module Helpers
  module User
    def create_user
      FactoryBot.create(:user,
        email: Faker::Internet.email,
        password: Faker::Internet.password
      )
    end

    def build_user
      FactoryBot.build(:user,
        email: Faker::Internet.email,
        password: Faker::Internet.password
      )
    end
  end
end
