# IV-Plurk

This is API Client for [Plurk](https://plurk.com).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'iv-plurk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iv-plurk

## Usage

By the default this gem will load credential from environment variables.

* PLURK_CONSUMER_KEY
* PLURK_CONSUMER_SECRET
* PLURK_OAUTH_TOKEN
* PLURK_OAUTH_SECRET


To convert your Plurk realtime timeline into webhook, you can use the command line to execute it.

```bash
iv-plurk -w WEBHOOK_URL
```

If you want to switch credential you can use `#use` method

```ruby
cred = IV::Plurk::Credential.new(
  consumer_key: 'XXX',
  consumer_secret: 'XXX',
  oauth_token: 'XXX',
  oauth_secret: 'XXX'
)

IV::Plurk.use(cred) do
  channel = IV::Plurk::Realtime.channel
  puts "The Comet Server is #{channel.server}"
end
```

### Realtime API

Get the realtime server

```ruby
IV::Plurk::Realtime.new(cred).channel
```

## Docker

This gem didn't design for on daemon, but you can use the docker with `restart always` option.

```bash
# Get the latest docker image
docker pull elct9620/iv-plurk

# Run it as daemon
docker run -d --restart=always -e PLURK_CONSUMER_KEY=XXX -e PLURK_CONSUMER_SECRET=XXX -e PLURK_OAUTH_SECRET=XXX -e PLURK_OAUTH_TOKEN=XXX elct9620/iv-plurk -w WEBHOOK_URL
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elct9620/iv-plurk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Iv::Plurk project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/elct9620/iv-plurk/blob/master/CODE_OF_CONDUCT.md).
