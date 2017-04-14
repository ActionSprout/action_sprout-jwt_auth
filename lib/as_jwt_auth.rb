require "as_jwt_auth/version"
require 'as_jwt_auth/verify_jwt'

module AsJWTAuth
  def self.verify_jwt(jwt, public_key: )
    verifier = VerifyJWT.new(public_key)
    verifier.valid? jwt
  end
end
