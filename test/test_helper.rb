ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment", __FILE__)

require "minitest/autorun"
require "pliable"
require "pry"
require "pry-debugger"

# Requires supporting ruby files with custom matchers and macros, etc,
# in test/support/ and its subdirectories.
Dir[File.join("./test/support/**/*.rb")].sort.each { |f| require f }

class DummyHelperClass < ActionView::Base
  include Rails.application.routes.url_helpers
end
