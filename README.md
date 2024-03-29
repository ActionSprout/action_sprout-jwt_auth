# ActionSprout::JWTAuth

This gem provides a method for handling JWT authentication between AS services.

## Installation

Add this line to your application's Gemfile:

```ruby
# make sure gemfury source is also in this file.
gem 'action_sprout-jwt_auth'
```

And then execute:

    $ bundle

## Usage

Here is an example of how ActionSprout::JWTAuth is used in ActionSprout/fern and ActionSprout/waterleaf.

```ruby
# Generate a JWT in fern
jwt_string = ActionSprout::JWTAuth.generate_jwt({ 'organization_id' => 1 }, issuer: 'as-fern', key: Fern.private_key)

# Verify that JWT in waterleaf
ActionSprout::JWTAuth.verify_jwt jwt_string, key: ferns_public_key # => true or false
```

## Rails Usage

### Controller Helpers

ActionSprout::JWTAuth provides a handy method that can be used as a `before_action`: `verify_jwt!`.

To use it, specify `verify_jwt!` as a `before_action`. For example:

```ruby
class MyController < ActionController::Base
  before_action :verify_jwt!
end
```

### Automatic Public Key Selection

By default `ActionSprout::JWTAuth` can make a HTTP request to get the public key it needs to verify the incomming JWT. Three environment variables are required for this to work:

* `JWT_KEY_SERVER_URL_TEMPLATE`

   A url template for where to find the public key. The parameter `{issuer}`
   will be filled with the `iss` from the incoming JWT.

   For example: `http://keys.actionsprout.com/api/keys/{issuer}`

* `APP_NAME`

  Used to generate a JWT to authenticate the request for a public key.

* `PRIVATE_KEY`

  Used to sign a JWT to authenticate the request for a public key.

The response from the key server is expected to be a JSONAPI resource object with the attribute `key` that contains the PEM representation of the public key.

#### Bypassing Automatic Public Key Selection

Internally, `ActionSprout::JWTAuth` calls `#public_key_for_jwt_auth` on your controller. To prevent it from making an HTTP request to find the public key to verify an incoming JWT, define `#public_key_for_jwt_auth` to return the PEM representation of the public key.


```ruby
class MyController < ActionController::Base
  before_action :verify_jwt!

  private

  def public_key_for_jwt_auth
    ENV.fetch('OTHER_APP_PUBLIC_KEY')
  end
end
```

### `aud` Verification

By default, `:verify_jwt!` verifies that the JWT includes the `aud` claim with the request url.

To generate a JWT that passes this verification, include an `'aud'` in the payload as an array with the url of the request.

Here is an example using HTTParty.

```ruby
url = 'http://example.com/api/people'
query = { name: 'Princess Buttercup' }
jwt = AsJWTAuth.generate_jwt('aud' => [url])
headers = { 'X-Auth' => jwt }
HTTParty.get url, query: query, headers: headers
```

#### Customizing `aud` Verification

The options used to verify the JWT can be customized by overwriting `jwt_options_for_verification` in the controller.

Please see the [`jwt-ruby` documentation](https://github.com/jwt/ruby-jwt) for examples of claims available for verification. Any claim supported by `jwt-ruby` can be specified in `jwt_options_for_verification`.

For example, to verify the request is issued by a specific app, try something like this:

```ruby
def jwt_options_for_verification
  { verify_iss: true, iss: 'other-app' }
end
```

Or, to disable this type of verification entirely:

```ruby
def jwt_options_for_verification
  {}
end
```

It is not recommended to disable this verification unless some other method is used to authorize the data returned (such as using something in the token to scope the data returned).

### Test Helpers

ActionSprout::JWTAuth provides some handy test helpers. For example:

```ruby
before { assume_valid_jwt from: 'as-issuer' }
# or
before { set_jwt_auth user_id: 1 }
```

### RSpec shared examples

ActionSprout::JWTAuth also provides a shared example to be used to verify that a request is protected by JWT. You must define the request.

The request can either be in a `before` block, or defined as `let(:request)`.

For example:

```ruby
it_should_behave_like 'a JWT authorized request' do
  let(:response) { get :index }
end
```

Or:

```ruby
context 'the index page' do
 let(:response) { get :index }
 it_should_behave_like 'a JWT authorized request'
end
```

If you are seeing this error and have defined a request, it is possible that your request is raising an exception. Check rspec results for other exceptions.

Some requests may require a specific JWT `sub`. You can define a custom value through `jwt_sub`:

```ruby
context 'the index page' do
 ...
 it_should_behave_like 'a JWT authorized request' do
  let(:jwt_sub) { ... }
 end
end
```


## Roadmap

Currently, each service so far already knows what other service is expected to
be making the call, but in the future, it may be that an endpoint is accessible
by more than one service. In this case, the service will need to determine who
has made the call in order to use the correct public key to verify with.

When we have that requirement, we plan to add logic and configuration to
ActionSprout::JWTAuth to handle finding the correct public key.

## Development

#### Setup
1. Check out repo `https://github.com/ActionSprout/action_sprout-jwt_auth.git`
2. `bin/setup` (this runs `bundle install`)
3. Run tests with `rake spec`

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

**Use locally**
To install this gem into a local project add to your Gemfile
```ruby
gem 'action_sprout-jwt_auth', path: 'relative/path/to/gem/repo'
```
and then `bundle install` in that project. Remember to add the Gemfury `source` before
using in production.

#### Release a new Version
Update the version number in `lib/action_sprout/jwt_auth/version.rb` and make you final version change commit.
Create a release tag with `gem_push=no rake release`.

Make sure you have the git remote `fury` added (can be called anything).

    $ git remote add fury https://PASSWORD@repo.fury.io/ORGANIZATION/


To release the new verison we push to our Gemfury repo.

    $ git push fury master
