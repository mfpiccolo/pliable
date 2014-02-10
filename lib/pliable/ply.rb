require 'active_record'

module Pliable
  class Ply < ActiveRecord::Base

    self.inheritance_column = 'ply_type'

    # Allows an ply to associate another ply as either a parent or child
    has_many :ply_relations
    has_many :parent_relations, class_name: "PlyRelation", foreign_key: "child_id"
    has_many :parents, through: :parent_relations, source: :parent
    has_many :child_relations, class_name: "PlyRelation", foreign_key: "parent_id"
    has_many :children, through: :child_relations, source: :child

    before_save :set_type, if: lambda {|ply| ply.otype.present? }

    after_initialize :set_ply_attributes
    after_initialize :define_ply_scopes

    def self.oldest_last_checked_time
      order('last_checked').first.last_checked
    end

    # Active Record override
    def self.all
      if current_scope
        current_scope.clone
      else
        if self.name == "Pliable::Ply"
          scope = relation
        else
          if self.try(:ply_type)
            scope = relation.where(otype: self.try(:ply_type))
          else
            scope = relation
          end
        end
        scope.default_scoped = true
        scope
      end
    end

    def self.ply_name(name)
      define_singleton_method(:ply_type) { name }
    end

    def to_param
      oid
    end

    private

    def set_ply_attributes
      if data.present?
        data.each do |key,value|
          instance_variable_set(('@' + key.to_s).to_sym, value)
          define_singleton_method(key.to_s) { instance_variable_get(('@' + key.to_s).to_sym) }
        end
      end
    end

    def define_ply_scopes
      # pluralize is not perfect.  ie. Merchandise__c => merchandises
      child_names  = children.pluck(:child_type).uniq
      parent_names = parents.pluck(:parent_type).uniq

      add_scopes(child_names, parent_names)
    end

    def add_scopes(child_names, parent_names)
      child_names.each do |name|
        define_singleton_method(scrub_for_scope(name)) do
          self.type.constantize.children.where(otype: name)
        end
      end

      parent_names.each do |name|
        define_singleton_method(scrub_for_scope(name)) do
          self.type.constantize.parents.where(otype: name)
        end
      end
    end

    # user initializer to overwrite this method
    def scrub_for_scope(name)
      if respond_to? :added_scrubber
        name = added_scrubber(name)
      end

      TextHelper.pluralize(name.downcase)
    end

    def set_type
      if respond_to? :added_scrubber
        self.ply_type = added_scrubber(self.otype)
      else
        self.ply_type = self.otype.gsub
      end
    end
  end # Ply
end # Pliable
