require 'jwt'
require 'securerandom'

module ActionSprout
  module JWTAuth
    class GenerateJWT
      # Sign with ECDSA using P-256 and SHA-256
      ALGORITHM = 'ES256'

      def initialize(key: , issuer: )
        @key = key
        @issuer = issuer
      end

      def generate(payload = {})
        JWT.encode payload.merge(claims), key, ALGORITHM
      end

      private

      attr_reader :key, :issuer

      def claims
        {
          iat: Time.now.to_i,
          iss: issuer,
          jid: SecureRandom.uuid,
        }
      end
    end
  end
end
