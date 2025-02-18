class RootApi < Grape::API
  version "v1", using: :path
  format :json
  content_type :json, "application/json"
  helpers V1::Helpers::Auth

  mount V1::UserApi
end
