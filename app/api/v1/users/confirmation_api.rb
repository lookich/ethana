module Users
  class ConfirmationApi < Grape::API
    desc "User email confirmation"
    route_setting :auth, disabled: true

    params do
      requires :user, type: Hash do
        requires :confirmation_token, type: String, desc: "User confirmation"
      end
    end
    post "confirm_email" do
      user = User.confirm_by_token(params[:user][:confirmation_token])
      if user
        unless user.confirmed?
          status 403
        else
          user.send_notification(user.email, I18n.t("notification.auth.complete.message_title"), I18n.t("notification.auth.complete.message_body"), "success", [ "push" ])
          status 200
          present user, with: Entities::UserEntity, token: token
        end
      else
        error!(I18n.t("auth.error.sign_in.invalid_token"), 401)
      end
    end
  end
end
