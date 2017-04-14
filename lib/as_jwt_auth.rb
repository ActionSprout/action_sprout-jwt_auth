require "as_jwt_auth/version"

module AsJWTAuth
  autoload :VerifyJWT, 'as_jwt_auth/verify_jwt'

  def self.generate_jwt(payload = {}, key: )
    JWT.encode payload, key, 'ES256'
  end

  def self.verify_jwt(jwt, public_key: )
    verifier = VerifyJWT.new(public_key)
    verifier.valid? jwt
  end
end
