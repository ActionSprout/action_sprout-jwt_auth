require "as_jwt_auth/version"

module AsJWTAuth
  autoload :VerifyJWT, 'as_jwt_auth/verify_jwt'

  def self.verify_jwt(jwt, public_key: )
    verifier = VerifyJWT.new(public_key)
    verifier.valid? jwt
  end
end
