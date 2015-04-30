# MigrationInvestigation

This gem will check to see if you need to run migrations without loading your environment.
It assumes that you are using [auto_tagger](https://github.com/zilkey/auto_tagger) to tag the SHA
that has been deployed.

## Installation

Add this line to your application's Gemfile:

    gem "migration_investigation"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install migration_investigation

## Usage

The gem is very simple:

  $ MigrationInvestigation.pending_migrations? "staging", "abc123"

Where `staging` is the name of the tag, and `abc123` is the SHA you're about to deploy.
You can also pass nil for the SHA you're about to deploy and it will assume you're deloying `HEAD`.

If you'd also like to check additional files or directories, say seed data, you can pass in a third
parameter:

  $ MigrationInvestigation.pending_migrations? "staging", "abc123", additional_paths: ["db/seed.rb", "app/foo.txt"]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
