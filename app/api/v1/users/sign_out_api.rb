module Users
  class SignOutApi < Grape::API
    namespace :sign_out do
      desc "User sign out"
      post do
        if current_user
          jwt = TokenProviderService.decoded_token(token)
          payload = { jti: jwt["jti"], aud: jwt["aud"] }
          User.revoke_jwt(payload, @current_user)
          status 200
        else
          error!(I18n.t("auth.error.sign_in.incorrect_auth_credentials"), 401)
        end
      end
    end
  end
end
