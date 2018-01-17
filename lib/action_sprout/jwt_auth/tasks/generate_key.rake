namespace :action_sprout do
  namespace :jwt_auth do
    task :generate_key do
      require 'openssl'

      key = OpenSSL::PKey::EC.new 'prime256v1'
      key.generate_key
      private_key = key.to_pem

      key.private_key = nil
      public_key = key.to_pem

      puts "New public/private key generated for use with jwt_auth"
      puts
      puts "Private Key"
      puts "-----------"
      puts
      puts "Add this private key to your project's environment (heroku config:set for production/staging and docker.env for develompent/test)"
      puts
      puts "    PRIVATE_KEY=#{private_key.inspect}"
      puts
      puts
      puts "Public Key"
      puts "----------"
      puts
      puts "Add this to huckleberry:config/app_keys.yml"
      puts
      puts "    as-app-name: #{public_key.inspect}"
      puts
      puts

    end
  end
end
