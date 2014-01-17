require "pliable/version"
require "pliable/ply"

module Pliable
  def self.included(base)
    base.send(:include, Pliable::Ply)
    super
  end
end
