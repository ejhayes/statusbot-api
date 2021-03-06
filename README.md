# Statusbot::Api [![Build Status](https://travis-ci.org/ejhayes/statusbot-api.svg?branch=master)](https://travis-ci.org/ejhayes/statusbot-api) [![Code Climate](https://codeclimate.com/github/ejhayes/statusbot-api/badges/gpa.svg)](https://codeclimate.com/github/ejhayes/statusbot-api) [![Test Coverage](https://codeclimate.com/github/ejhayes/statusbot-api/badges/coverage.svg)](https://codeclimate.com/github/ejhayes/statusbot-api) [![Dependency Status](https://gemnasium.com/ejhayes/statusbot-api.svg)](https://gemnasium.com/ejhayes/statusbot-api)

Provides the API used by the statusbot.me worker processes.

## Installation

Add this line to your application's Gemfile:

    gem 'statusbot-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install statusbot-api

## Generating the database

This gem uses models from `statusbot-models` gem, so you'll need to run the migrations in order to get everything running.  For development work, this gem is configured to use sqlite3.

    bundle exec statusbot-models db:migrate

## Public API

The following methods are available to the workers.

- add_update(description)
- get_updates()
- add_goal(description)
- get_goals()
- add_wait(description)
- get_waits()
- remind(wait_id)
- done()

## To Do

The following things still need to be done at some point.

- get_full_report()

## Contributing

1. Fork it ( https://github.com/ejhayes/statusbot-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
