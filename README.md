# contwinue

Twitter cont.

[contwinue.com](http://contwinue.com/)

If your Tweet is longer than 140 characters, contwinue will break it up into smaller tweets for you automatically.

## Setup

contwinue has been developed using the following:

* Ruby 2
* Rails 4
* MongoDB
* Unicorn

To get setup for development, execute:

```ruby
bundle install
```

To run the tests, execute one of the following:

* Run all the tests: `rake`
* Automatically watch the files changed and run the correct tests during development: `guard`

To run the server, execute:

```ruby
unicorn -c config/unicorn.rb
```

## Ideas

* User-configurable continuation text
* Better UI
  * Improved preferences page
  * Character count on tweet page

## Contributing to contwinue

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.

## Copyright

Copyright (c) 2013 David Czarnecki. See LICENSE.txt for further details.
