require 'jwt'
require 'securerandom'

module AsJWTAuth
  class GenerateJWT
    # Sign with ECDSA using P-256 and SHA-256
    ALGORITHM = 'ES256'

    def initialize(key, app: nil)
      @key = key
      @app = app
    end

    def generate(payload = {})
      JWT.encode payload, key, ALGORITHM, headers
    end

    private

    attr_reader :key, :app, :extra_header_attributes

    def headers
      {
        iat: Time.now.to_i,
        iss: app,
        jid: SecureRandom.uuid,
      }
    end
  end
end

