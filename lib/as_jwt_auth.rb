require 'as_jwt_auth/version'
require 'as_jwt_auth/verify_jwt'
require 'as_jwt_auth/generate_jwt'
require 'as_jwt_auth/jwt_header'
require 'as_jwt_auth/railtie' if defined?(Rails)

module AsJWTAuth
  def self.generate_jwt(payload = {}, key: )
    GenerateJWT.new(key).generate payload
  end

  def self.verify_jwt(jwt, key: )
    verifier = VerifyJWT.new(key)
    verifier.valid? jwt
  end

  def self.jwt_header(jwt)
    JWTHeader.call jwt
  end
end
