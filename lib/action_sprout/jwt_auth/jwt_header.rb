require 'jwt'

module ActionSprout
  module JWTAuth
    class JWTHeader
      def self.call(jwt)
        _payload, headers = JWT.decode jwt, nil, false
        headers
      end

      def self.issuer(jwt)
        call(jwt)['iss']
      end
    end
  end
end
