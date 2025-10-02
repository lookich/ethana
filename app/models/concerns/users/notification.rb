module Users::Notification
  extend ActiveSupport::Concern

  def send_notification(user_email = "", title = "", body = "", notification_type = "", reciever_type = [])
    notification = Notification.create(user_id: self.id, title: title, body: body, notification_type: notification_type, reciever_type: reciever_type)
    DirectExchangeUserNotificationPublisher.new(
      message: {
        notification_id: notification.id,
        notification_type: notification.notification_type,
        user_id: notification.user_id,
        title: notification.title,
        body: notification.body,
        viewed: notification.viewed,
        created_at: notification.created_at
      },
      options: {
        routing_key: "notification_process/" + user_email,
        queue_name: "notification-" + user_email
      }
    ).publish
  end
end
