module Helpers
  module Api
    def authenticated_headers(request, token)
      auth_header = { 'Authorization' => token, 'JWT_AUD' => 'UNKNOWN_AUD' }
      request.headers.merge!(auth_header)
    end

    def res_json_body
      JSON.parse(response.body)
    end
  end
end
