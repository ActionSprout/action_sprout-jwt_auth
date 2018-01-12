require 'as_jwt_auth/get_public_key'

module AsJWTAuth
  module RailsControllerHelpers
    def verify_jwt!
      if !jwt_authorized?
        logger.warn "AsJWTAuth: Unauthorized JWT: #{jwt_auth_header}"
        render json: jwt_unauthorized_response_data, status: :unauthorized
      end
    end

    def jwt_authorized?
      key = OpenSSL::PKey::EC.new public_key_for_jwt_auth
      AsJWTAuth.verify_jwt jwt_auth_header, key: key
    end

    def jwt_auth_header
      request.env['HTTP_X_AUTH']
    end

    def public_key_for_jwt_auth
      AsJWTAuth::GetPublicKey.call jwt_auth_header
    end

    def jwt_unauthorized_response_data
      {
        errors: [{
          status: '401',
          title: 'Unauthorized',
          detail: 'This request is unauthorized.',
        }],
      }
    end
  end
end
