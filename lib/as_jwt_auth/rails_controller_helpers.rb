module AsJWTAuth
  module RailsControllerHelpers
    def verify_jwt!
      if !jwt_authorized?
        logger.warn "AsJWTAuth: Unauthorized JWT: #{jwt_auth_header}"
        render json: {}, status: :unauthorized
      end
    end

    def jwt_authorized?
      key = OpenSSL::PKey::EC.new public_key_for_jwt_auth
      AsJWTAuth.verify_jwt jwt_auth_header, key: key
    end

    def jwt_auth_header
      request.env['HTTP_X_AUTH']
    end

    def jwt_app_name
      headers = AsJWTAuth.jwt_header jwt_auth_header
      headers['iss']
    end

    def public_key_for_jwt_auth
      raise NoMethodError, '#public_key is currently required to use verify_jwt! In the future this can happen automatically'
    end
  end
end
