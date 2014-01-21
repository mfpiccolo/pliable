class FooAlias < ActiveRecord::Base
  # database trigger maintains *_tsquery versions
  attr_accessible :original, :substitution
end