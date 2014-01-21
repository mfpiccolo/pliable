require "pliable/version"
require "pliable/ply"
require "pliable/ply_relation"
require "pliable/configure"
require "pliable/text_helper"

module Pliable
  extend Configure

  def self.included(base)
    base.send(:include, Pliable::Ply)
    base.send(:include, Pliable::PlyRelation)
    base.send(:include, Pliable::TextHelper)
    super
  end

end
