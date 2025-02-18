module V1
  module Users
    class SignInApi < Grape::API
      namespace :sign_in do
        desc "Authenticate user and return user object / access token"
        route_setting :auth, disabled: true
        params do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User Password"
        end

        post do
          user = User.find_by(email: params[:email])
          if user&.valid_password?(params[:password])
            token, payload = TokenProviderService.encode_token(user, jwt_aud)
            user.on_jwt_dispatch(token, payload)

            status 200
            present user, with: Entities::UserEntity, token: token
          else
            error!("Unauthorized. Incorrect email/password.", 401)
          end
        end
      end
    end
  end
end
