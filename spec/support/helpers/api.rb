module Helpers
  module Api
    def authenticated_headers(request, token)
      auth_header = { 'Authorization' => token, 'JWT_AUD' => jwt_aud }
      request.headers.merge!(auth_header)
    end

    def res_json_body
      JSON.parse(response.body)
    end

    def jwt_aud
      'UNKNOWN_AUD'
    end

    def sign_in(user)
      signin_url = '/api/v1/user/sign_in'
      post signin_url, params: {
        user: {
          email: user.email,
          password: user.password
        }
      }
      @auth_token = res_json_body['user']['token']
    end
  end
end
