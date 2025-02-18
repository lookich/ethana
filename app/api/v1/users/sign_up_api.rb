module V1
  module Users
    class SignUpApi < Grape::API
      namespace :sign_up do
        # User Sign Up API
        desc "Create new user and return user object / access token"
        route_setting :auth, disabled: true
        params do
          requires :email, type: String
          requires :password, type: String
          optional :mobile_phone, type: String
        end
        post do
          user = User.new(declared(params))
          if user.valid? && user.save
            token, payload = TokenProviderService.encode_token(user, jwt_aud)
            user.on_jwt_dispatch(token, payload)

            status 201
            present user, with: Entities::UserEntity, token: token
          else
            error!("User couldn't be created successfully.", 422)
          end
        end
      end
    end
  end
end
