require 'jwt'
require 'securerandom'

module AsJWTAuth
  class GenerateJWT
    # Sign with ECDSA using P-256 and SHA-256
    ALGORITHM = 'ES256'

    def initialize(key: , issuer: )
      @key = key
      @issuer = issuer
    end

    def generate(payload = {})
      JWT.encode payload, key, ALGORITHM, headers
    end

    private

    attr_reader :key, :issuer, :extra_header_attributes

    def headers
      {
        iat: Time.now.to_i,
        iss: issuer,
        jid: SecureRandom.uuid,
      }
    end
  end
end

