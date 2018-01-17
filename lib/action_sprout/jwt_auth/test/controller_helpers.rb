module ActionSprout
  module JWTAuth
    module Test
      module ControllerHelpers
        def set_jwt_auth(jwt, jwt_result: {}, issuer: jwt_issuer)
          request.env['HTTP_X_AUTH'] = jwt

          key_matcher = instance_of(OpenSSL::PKey::EC)
          a_key = OpenSSL::PKey::EC.new('prime256v1')

          allow(ActionSprout::JWTAuth::GetPublicKey).to receive(:call).with(jwt: jwt).and_return a_key
          allow(ActionSprout::JWTAuth).to receive(:jwt_issuer).with(jwt).and_return issuer

          if jwt_result
            payload = make_jwt_claims.merge(jwt_result)
            allow(ActionSprout::JWTAuth).to receive(:jwt_body).with(jwt, key: key_matcher).and_return payload
            allow(ActionSprout::JWTAuth).to receive(:verify_jwt).with(jwt, key: key_matcher).and_return payload
          else
            allow(ActionSprout::JWTAuth).to receive(:verify_jwt).with(jwt, key: key_matcher).and_return false
          end
        end

        def assume_valid_jwt(from: jwt_issuer)
          set_jwt_auth 'A.JWT', jwt_result: make_jwt_claims(iss: from), issuer: from
        end

        def make_jwt_claims(iss: jwt_issuer)
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
end
