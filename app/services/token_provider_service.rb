module TokenProviderService
  class << self
    def encode_token(user, aud)
      Warden::JWTAuth::UserEncoder.new.call(user, :user, aud)
    end

    def decoded_token(token)
      Warden::JWTAuth::TokenDecoder.new.call(token)
    end

    def find_by_token(token, aud = nil)
      Warden::JWTAuth::UserDecoder.new.call(token, :user, aud)
    end
  end
end
