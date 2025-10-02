module Users
  class ResetPasswordApi < Grape::API
    desc "User password reset instructions"
    route_setting :auth, disabled: true

    params do
      requires :user, type: Hash do
        requires :email, type: String, desc: "User email"
      end
    end
    post "reset_password_instructions" do
      user = User.find_by(email: params[:user][:email])
      if user
        user.send_reset_password_instructions
        status 200
      else
        error!(I18n.t("auth.error.user_not_found"), 401)
      end
    end

    desc "User password reset"
    route_setting :auth, disabled: true

    params do
      requires :user, type: Hash do
        requires :password, type: String, desc: "User password"
        requires :password_confirmation, type: String, desc: "User password confirmation"
        requires :reset_password_token, type: String, desc: "User password"
      end
    end
    post "reset_password" do
      user = User.find_by(reset_password_token: params[:user][:reset_password_token])
      if user && user.reset_password_period_valid?
        user.reset_password(params[:user][:password], params[:user][:password_confirmation])
        status 200
      elsif user && !user.reset_password_period_valid?
        error!(I18n.t("auth.error.user_token_expired"), 498)
      else
        error!(I18n.t("auth.error.user_not_found"), 401)
      end
    end
  end
end
