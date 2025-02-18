module V1
  module Users
    class SignOutApi < Grape::API
      namespace :sign_out do
        desc "User sign out"
        delete do
          if current_user
            jwt = TokenProviderService.decoded_token(token)
            payload = { jti: jwt["jti"], aud: jwt["aud"] }
            User.revoke_jwt(payload, @current_user)
            status 200
          else
            error!("Unauthorized.", 401)
          end
        end
      end
    end
  end
end
