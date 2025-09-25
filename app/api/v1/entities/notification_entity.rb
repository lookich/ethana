module Entities
  class NotificationEntity < Grape::Entity
    root "notifications"
    expose :id
    expose :notification_type
    expose :user_id
    expose :title
    expose :body
    expose :viewed
    expose :created_at do |object, options|
      object.created_at.strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
