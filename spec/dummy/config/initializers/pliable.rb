Pliable.configure do |config|
  # Add logic to this bloc to change the names given by external services so we can pluralize.
  # For instance if you ply names need to gsub __c of the end do:
  config.added_scrubber {|name| name.gsub('__c', '') }
end
