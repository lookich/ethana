require 'faker'

FactoryBot.define do
  factory :unconfirmed_user, class: 'User' do
    email { Faker::Internet.email }
    password { 'Password' }
    password_confirmation { 'Password' }
    mobile_phone { Faker::PhoneNumber.phone_number_with_country_code }
  end

  factory :confirmed_user, class: 'User' do
    email { Faker::Internet.email }
    password { 'Password' }
    password_confirmation { 'Password' }
    mobile_phone { Faker::PhoneNumber.phone_number_with_country_code }
    confirmed_at { Time.now }
  end
end
