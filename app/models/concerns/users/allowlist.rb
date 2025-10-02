module Users::Allowlist
  extend ActiveSupport::Concern

  included do
    has_many :allowlisted_jwts, dependent: :destroy

    # Warden::JWTAuth::Interfaces::RevocationStrategy#jwt_revoked?
    def self.jwt_revoked?(payload, user)
      !user.allowlisted_jwts.exists?(payload.slice("jti", "aud"))
    end

    # Warden::JWTAuth::Interfaces::RevocationStrategy#revoke_jwt
    def self.revoke_jwt(payload, user)
      jwt = user.allowlisted_jwts.find_by(payload.slice("jti", "aud"))
      jwt.destroy! if jwt
    end
  end


  # Warden::JWTAuth::Interfaces::User#on_jwt_dispatch
  def on_jwt_dispatch(_token, payload)
    prev_token = allowlisted_jwts.active.where(aud: payload["aud"]).last
    token = allowlisted_jwts.create!(
      jti: payload["jti"],
      aud: payload["aud"].presence,
      exp: Time.at(payload["exp"].to_i)
    )

    if token.present? && prev_token.present?
      token.update_columns({
        browser_data: prev_token.browser_data,
        os_data: prev_token.os_data,
        remote_ip: prev_token.remote_ip
      })
      # NOTE: don't destroy the previous token right away in case
      # user opens new tab, or whatever and needs to do something...
      # prev_token.destroy!
    end
    token
  end
end
