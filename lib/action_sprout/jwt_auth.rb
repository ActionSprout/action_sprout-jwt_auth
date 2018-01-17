require 'action_sprout/jwt_auth/version'
require 'action_sprout/jwt_auth/generate_jwt'
require 'action_sprout/jwt_auth/jwt_body'
require 'action_sprout/jwt_auth/verify_jwt'
require 'action_sprout/jwt_auth/railtie' if defined?(Rails)

module ActionSprout
  module JWTAuth
    def self.generate_jwt(payload = {}, issuer: default_issuer, key: default_private_key)
      GenerateJWT.new(key: key, issuer: issuer).generate payload
    end

    def self.jwt_body(jwt, key: )
      JWTBody.call jwt: jwt, key: key
    end

    def self.verify_jwt(jwt, key: )
      verifier = VerifyJWT.new(key)
      verifier.valid? jwt
    end

    def self.jwt_issuer(jwt)
      payload, _headers = JWT.decode jwt, nil, false
      payload['iss']
    end

    def self.default_issuer
      ENV.fetch('APP_NAME') do
        raise ArgumentError, 'Missing issuer. Either pass an issuer or define the environment variable APP_NAME'
      end
    end

    def self.default_private_key
      pem = ENV.fetch('PRIVATE_KEY') do
        raise ArgumentError, 'Missing private key. Either pass a key or define the environment variable PRIVATE_KEY'
      end

      # When pulling a private key from the environment, it is common to
      # accidentally have newlines escaped. This `gsub` will work when newlines
      # are correctly newlines and when newlines are escaped.
      OpenSSL::PKey::EC.new pem.gsub('\n', "\n")
    end
  end
end
