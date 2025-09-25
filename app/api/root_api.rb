class RootApi < Grape::API
  require "./app/api/v1/helpers/auth"
  version "v1", using: :path
  prefix :api
  format :json
  content_type :json, "application/json"
  helpers Auth
  before do
    authenticate! unless route.settings && route.settings[:auth] && route.settings[:auth][:disabled]
  end

  mount UserApi
end
