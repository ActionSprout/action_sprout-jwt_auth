require 'jwt'

module AsJWTAuth
  class GenerateJWT
    # Sign with ECDSA using P-256 and SHA-256
    ALGORITHM = 'ES256'

    def initialize(key)
      @key = key
    end

    def generate(payload = {})
      JWT.encode payload, key, ALGORITHM
    end

    private

    attr_reader :key
  end
end

