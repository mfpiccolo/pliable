pliable
============
| Project                 |  Gem Release      |
|------------------------ | ----------------- |
| Gem name                |  pliable      |
| License                 |  [MIT](LICENSE.txt)   |
| Version                 |  [![Gem Version](https://badge.fury.io/rb/pliable.png)](http://badge.fury.io/rb/pliable) |
| Continuous Integration  |  [![Build Status](https://travis-ci.org/mfpiccolo/pliable.png?branch=master)](https://travis-ci.org/mfpiccolo/pliable)
| Test Coverage           |  [![Coverage Status](https://coveralls.io/repos/mfpiccolo/pliable/badge.png?branch=master)](https://coveralls.io/r/mfpiccolo/pliable?branch=coveralls)
| Grade                   |  [![Code Climate](https://codeclimate.com/github/mfpiccolo/pliable.png)](https://codeclimate.com/github/mfpiccolo/pliable)
| Homepage                |  [http://mfpiccolo.github.io/pliable][homepage] |
| Documentation           |  [http://rdoc.info/github/mfpiccolo/pliable/frames][documentation] |
| Issues                  |  [https://github.com/mfpiccolo/pliable/issues][issues] |

## Description

Pliable makes integrating a Rails project with Schemaless data not so painful.

## Features

## Examples

Two main steps:

1.  Install and require the gem
2.  Add `MinitestVcr::Spec.configure!` before your tests load

The setup below will create a direcotry structre that looks like this:

    |-- app_name
    |  |-- test/
    |    |-- cassettes/
    |      |-- Example_Spec/
    |        |-- an_example_group/
    |          |-- with_a_nested_example_group/
    |          `-- uses_a_cassette_for_an_example_group.yml
    |    `-- example_test.rb
    |    `-- test_helper.rb

An example test_helper file: app_name/test/test_helper.rb

```ruby
require "minitest/autorun"
require "minispec-metadata"
require "vcr"
require "pliable"
require "webmock"
require "mocha/setup"
require "faraday"

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
end

MinitestVcr::Spec.configure!
```

An example test file: app_name/test/example_test.rb

```ruby
require "test_helper"

describe Example::Spec do

  # Notice here symbols are treated as true values
  # You could also do vcr: true
  describe 'an example group', :vcr do
    describe 'with a nested example group' do
      before do
        conn = Faraday.new
        @response = conn.get 'http://example.com'
      end
      it 'uses a cassette for any examples' do
        @response.wont_equal nil
      end
    end
  end
end
```

## Requirements


## Installation

Add this line to your application's Gemfile:

```ruby
gem "pliable"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pliable

## Donating
Support this project and [others by mfpiccolo][gittip-mfpiccolo] via [gittip][gittip-mfpiccolo].

[gittip-mfpiccolo]: https://www.gittip.com/mfpiccolo/

## Copyright

Copyright (c) 2013 Mike Piccolo

See [LICENSE.txt](LICENSE.txt) for details.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/pliable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/e1a155a07163d56ca0c4f246c7aa8766 "githalytics.com")](http://githalytics.com/mfpiccolo/pliable)

[license]: https://github.com/mfpiccolo/pliable/MIT-LICENSE
[homepage]: http://mfpiccolo.github.io/pliable
[documentation]: http://rdoc.info/github/mfpiccolo/pliable/frames
[issues]: https://github.com/mfpiccolo/pliable/issues

