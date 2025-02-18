module V1
  module Entities
    class UserEntity < Grape::Entity
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
