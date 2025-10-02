module Users
  class SignUpApi < Grape::API
    namespace :sign_up do
      # User Sign Up API
      desc "Create new user and return user object / access token"
      route_setting :auth, disabled: true
      params do
        requires :user, type: Hash do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
          requires :password_confirmation, type: String, desc: "User password confirmation"
          optional :mobile_phone, type: String, desc: "User mobile phone"
        end
        optional :browser, type: Hash, desc: "Browser data"
        optional :os, type: String, desc: "OS data"
      end

      post do
        user = User.new(declared(params)[:user])
        if user.valid? && user.save
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

          status 201
          present user, with: Entities::UserEntity, token: token
        elsif user.errors.where(:email, :taken)
          error!(I18n.t("auth.error.sign_up.email.taken"), 422)
        else
          error!(I18n.t("auth.error.sign_up.failed"), 422)
        end
      end
    end
  end
end
