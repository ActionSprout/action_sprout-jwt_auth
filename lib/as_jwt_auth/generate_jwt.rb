require 'jwt'

module AsJWTAuth
  class GenerateJWT

    def initialize(key)
      @key = key
    end

    def generate(payload = {})
      JWT.encode payload, key, 'ES256'
    end

    private

    attr_reader :key
  end
end

