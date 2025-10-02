module Entities
  class UserEntity < Grape::Entity
    expose :user do
      expose :id
      expose :email
      expose :mobile_phone
      expose :admin
      expose :blocked
      expose :token, if: lambda { |object, options| options[:token] } do |object, options|
        options[:token]
      end
    end
  end
end
