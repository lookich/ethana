module V1::Helpers::Auth
  extend Grape::API::Helpers

  def authenticate!
    current_user
  rescue
    error!("Unauthorized. Invalid or expired token.", 401)
  end

  def current_user
    @current_user =  TokenProviderService.find_by_token(token, jwt_aud) if token
  end

  def token
    headers["Authorization"].to_s.split.last if headers["Authorization"]
  end

  def jwt_aud
    if headers["jwt-aud"]
      headers["jwt-aud"]
    else
      "UNKNOWN_AUD"
    end
  end
end
