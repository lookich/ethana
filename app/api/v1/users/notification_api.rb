module Users
  class NotificationApi < Grape::API
    namespace :notifications do
      desc "Get user notifications"
      params do
        optional :notification_numbers, type: Integer, desc: "Numbers of last notifications"
      end
      get do
        if params[:notification_numbers]
          status 200
          present current_user.notifications.order(id: :desc).last(params[:notification_numbers]), with: Entities::NotificationEntity
        else
          status 200
          present current_user.notifications, with: Entities::NotificationEntity
        end
      end

      namespace ":id" do
        desc "Update user notification"
        params do
          requires :id, type: Integer, desc: "Notification id"
          requires :notification, type: Hash, desc: "Notification attributes"
        end
        put do
          notification = current_user.notifications.find_by(id: params[:id])
          if notification.update(params[:notification])
            status 200
            (current_user.notifications.unviewed.count > 0) ? true : false
          else
            status 500
          end
        end

        desc "Delete user notification"
        params do
          requires :id, type: Integer, desc: "Notification id"
        end
        delete do
          notification = current_user.notifications.find_by(id: params[:id])
          if notification.delete
            status 200
          else
            status 500
          end
        end
      end
    end
  end
end
