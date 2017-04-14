# AsJWTAuth

This gem provides a method for handling JWT authentication between AS services.

## Installation

Add this line to your application's Gemfile:

```ruby
# make sure gemfury source is also in this file.
gem 'as_jwt_auth'
```

And then execute:

    $ bundle

## Usage

Here is an example of how AsJWTAuth is used in ActionSprout/fern and ActionSprout/waterleaf.

```ruby
# Generate a JWT in fern
jwt_string = AsJWTAuth.generate_jwt({ 'aud' => 'as-waterleaf' }, key: Fern.private_key)

# Verify that JWT in waterleaf
AsJWTAuth.verify_jwt jwt_string, key: ferns_public_key # => true or false
```

## Roadmap

Currently, each service so far already knows what other service is expected to
be making the call, but in the future, it may be that an endpoint is accessible
by more than one service. In this case, the service will need to determine who
has made the call in order to use the correct public key to verify with.

When we have that requirement, we plan to add logic and configuration to
AsJWTAuth to handle finding the correct public key.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
