FactoryBot.define do
  factory :notification do
    association :user, factory: :confirmed_user
    notification_type { "success" }
    reciever_type { [ "push" ] }
    title { "Welcome" }
    body { "Welcome to our project" }
    viewed { false }
  end
end
