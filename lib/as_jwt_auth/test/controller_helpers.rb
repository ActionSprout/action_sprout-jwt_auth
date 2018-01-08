module AsJWTAuth
  module Test
    module ControllerHelpers
      def set_jwt_auth(jwt, jwt_result: true)
        # TODO: Try `header 'X-Auth', jwt
        request.env['HTTP_X_AUTH'] = jwt
        allow(AsJWTAuth).to receive(:verify_jwt).with(jwt, key: instance_of(OpenSSL::PKey::EC)).and_return jwt_result
      end

      def assume_valid_jwt
        set_jwt_auth 'A.JWT'
      end
    end
  end
end
