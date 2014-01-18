require "pliable/version"
require "pliable/ply"
require "pliable/ply_relation"

module Pliable
  def self.included(base)
    base.send(:include, Pliable::Ply)
    base.send(:include, Pliable::PlyRelation)
    super
  end

  def self.configure
    yield self if block_given?
  end


end
