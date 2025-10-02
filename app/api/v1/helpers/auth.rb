module Auth
  extend Grape::API::Helpers

  def authenticate!
    error!(I18n.t("auth.error.sign_in.invalid_token"), 401) if !current_user
  end

  def current_user
    begin
      if token
        @current_user = TokenProviderService.find_by_token(token, jwt_aud)
      else
        false
      end
    rescue Warden::JWTAuth::Errors::NilUser => error
      error
    end
  end

  def token
    Rails.logger.info "AAAAAAAAAAAAAAAAA #{headers}"
    (headers["Authorization"] || headers["authorization"]).to_s.split.last if headers["Authorization"] || headers["authorization"]
  end

  def jwt_aud
    if headers["JWT-AUD"]
      headers["JWT-AUD"]
    elsif headers["jwt-aud"]
      headers["jwt-aud"]
    else
      "UNKNOWN_AUD"
    end
  end
end
