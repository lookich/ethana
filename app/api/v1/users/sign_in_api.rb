module Users
  class SignInApi < Grape::API
    namespace :sign_in do
      desc "Authenticate user and return user object / access token"
      route_setting :auth, disabled: true
      params do
        requires :user, type: Hash do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User Password"
        end
        optional :browser, type: Hash, desc: "Browser data"
      end

      post do
        user = User.find_by(email: params[:user][:email])
        if user&.valid_password?(params[:user][:password]) && user.confirmed?
          if params[:browser]
            browser, version, os = params[:browser][:name], params[:browser][:version], params[:browser][:os]
            digest = Digest::SHA256.hexdigest("#{os}#{browser}#{version}") if os
            possible_aud = headers["JWT-AUD"].presence || headers["jwt-aud"].presence
            if digest != possible_aud
              raise "Unmatched AUD"
            end
          end

          token, payload = TokenProviderService.encode_token(user, jwt_aud)
          user.on_jwt_dispatch(token, payload)
          last = user.allowlisted_jwts.where(aud: possible_aud).last
          if last.present?
            last.update_columns({
              browser_data: browser,
              os_data: os
            })
          end

          status 200
          present user, with: Entities::UserEntity, token: token
        elsif user && user.unconfirmed?
          error!(I18n.t("auth.error.sign_in.unconfirmed"), 403)
        else
          error!(I18n.t("auth.error.sign_in.incorrect_auth_credentials"), 401)
        end
      end
    end
  end
end
