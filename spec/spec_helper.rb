# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "active_record"
require "pry"
require "pry-debugger"
require "database_cleaner"

#grr-can't make this work quickly
Dir.glob("spec/dummy/spec/factories/*.rb").each do |file|
  puts "loading #{file}"
   load "#{file}"
end
Rails.backtrace_cleaner.remove_silencers!

# force include of our gem

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

