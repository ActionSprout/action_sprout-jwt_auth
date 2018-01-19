require 'jwt'
require 'securerandom'
require 'kwattr'

module ActionSprout
  module JWTAuth
    class GenerateJWT
      kwattr :key, :issuer

      # Sign with ECDSA using P-256 and SHA-256
      ALGORITHM = 'ES256'

      def generate(payload = {})
        JWT.encode payload.merge(claims), key, ALGORITHM
      end

      private

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
