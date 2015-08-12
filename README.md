# ActionKit

Action kit is a bunch of patterns I've used around the excellent [interactor](https://github.com/collectiveidea/interactor) gem. 

This is currently half-baked as its just being extracted from projects. Hopefully I will find some time to make it more robust.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action_kit', github: 'robhurring/action_kit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_kit

## Usage

##### Basic Context Contracts

`Action` provides very basic input/output contracts by checking that the context has the proper `expects` keys set, and returns the proper `promises` keys on successful runs.

```ruby
# app/actions/login_user.rb
class LoginUser
  include Action

  expects :username, :password
  promises :logged_in

  def call
    if User.login(username, password)
      context.logged_in = true
    else
      context.fail!
    end
  end

  private

  delegate :username, :password, to: :context
end
```

##### Basic Caching

`ActionCache` provides basic interactor result caching. 

* Caching defaults to using `Marshal` as its serializer to keep complex objects safe -- this can be swapped out by changing `ActionCache.serializer` to anything that implements `#dump` and `#load` (see: [ActionCache::Serializer::Marshal](lib/action_kit/serializer/marshal.rb))
* To swap out the cache you can change `ActionCache.cache` to any object that implements `#fetch(key, options, &block)` (see: [ActionCache::Cache::Worthless](lib/action_kit/cache/worthless.rb))

*NOTE:* This only caches successful calls. If `context.failure?` is true then no caching will take place.

**WARNING:** Merging `OpenStruct` contexts is tricky and not one-size-fits-all (at least not yet). Have a look at the [context merging strategies](lib/action_kit/merge_strategy) to see what can work. The default is [paranoid](lib/action_kit/merge_strategy/paranoid.rb) and only sets *new* keys on the context instead of overwriting anything.

```ruby
# config/initializers/action_kit
ActionKit::ActionCache.cache = Rails.cache
ActionKit::ActionCache.logger = Rails.logger
ActionKit::ActionCache.enabled = !Rails.env.test?

# app/actions/get_user.rb
class GetUser
  include Action
  include ActionCache

  cache_key do |context|
    %(users:#{context.username})
  end

  expires_in 1.hour

  expects :username
  promises :user

  def call
    response = api.get(username)

    if response.success?
      context.user = response.user
    else
      context.fail!(error: response.error)
    end
  end

  private

  delegate :username, to: :context

  def api
    Company::API::Users
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/action_kit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

