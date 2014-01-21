Pliable.configure do |config|
  # define scoipify here.  For instance if you ply names need to gsub __c of the end do:
  config.added_scrubber {|name| name.gsub('__c', '') }
end
