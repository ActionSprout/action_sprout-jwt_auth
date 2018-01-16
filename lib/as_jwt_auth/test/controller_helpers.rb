module AsJWTAuth
  module Test
    module ControllerHelpers
      def set_jwt_auth(jwt, jwt_result: true, jwt_header: make_jwt_header)
        request.env['HTTP_X_AUTH'] = jwt

        allow(AsJWTAuth).to receive(:jwt_header).with(jwt).and_return jwt_header
        allow(AsJWTAuth::JWTHeader).to receive(:call).with(jwt).and_return jwt_header
        allow(AsJWTAuth::JWTHeader).to receive(:issuer).with(jwt).and_return jwt_header['iss']
        a_key = OpenSSL::PKey::EC.new('prime256v1')
        allow(AsJWTAuth::GetPublicKey).to receive(:call).with(jwt: jwt).and_return a_key
        allow(AsJWTAuth).to receive(:verify_jwt).with(jwt, key: instance_of(OpenSSL::PKey::EC)).and_return jwt_result
      end

      def assume_valid_jwt(from: jwt_issuer)
        set_jwt_auth 'A.JWT', jwt_header: make_jwt_header(iss: from)
      end

      def make_jwt_header(iss: jwt_issuer)
        {
          'iss' => iss,
          'iat' => Time.now.to_i,
          'jid' => SecureRandom.uuid,
        }
      end

      def jwt_issuer
        'default-jwt-issuer'
      end

    end
  end
end
