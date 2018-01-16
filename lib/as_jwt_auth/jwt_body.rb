require 'jwt'
require 'action_sprout/method_object'

module AsJWTAuth
  class JWTBody
    extend ActionSprout::MethodObject
    method_object :jwt, :key

    def call
      payload, _headers = JWT.decode jwt, key, true, jwt_options

      # Return only the body. Clients can use `AsJWTAuth.jwt_header` to get the
      # header without verifying the JWT signature.
      payload
    end

    private

    def jwt_options
      { algorithm: 'ES256' }
    end

  end
end
