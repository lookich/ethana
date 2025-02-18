module V1
  class UserApi < Grape::API
    before do
      authenticate! unless route.settings[:auth] && route.settings[:auth][:disabled]
    end

    desc "End-points for the User"
    namespace :user do
      mount V1::Users::SignUpApi
      mount V1::Users::SignInApi
      mount V1::Users::SignOutApi

      desc "Current user "
      get ":current_user" do
        present current_user, with: Entities::UserEntity
      end

      desc "Update user"
      params do
        requires :id, type: Integer
      end
      route_param :id do
        put do
          User.find(params[:id]).update(declared(params))
        end
      end

      desc "Show user"
      params do
        requires :id, type: Integer
      end
      get ":id" do
        present User.find(params[:id]), with: Entities::UserEntity
      end

      desc "Delete user"
      params do
        requires :id, type: Integer
      end
      route_param :id do
         delete do
          user = User.find(params[:id])
          user.destroy
         end
      end
    end

    namespace :users do
      desc "Users list"
      get do
        present User.all, with: Entities::UserEntity
      end
    end
  end
end
