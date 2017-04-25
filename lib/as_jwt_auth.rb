require "as_jwt_auth/version"

module AsJWTAuth
  autoload :VerifyJWT, 'as_jwt_auth/verify_jwt'
  autoload :GenerateJWT, 'as_jwt_auth/generate_jwt'

  def self.generate_jwt(payload = {}, key: )
    GenerateJWT.new(key).generate payload
  end

  def self.verify_jwt(jwt, key: )
    verifier = VerifyJWT.new(key)
    verifier.valid? jwt
  end
end
