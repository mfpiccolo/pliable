require 'active_record'

module Pliable
  class Ply < ActiveRecord::Base
    belongs_to :user

    # Allows an ply to associate another ply as either a parent or child
    has_many :ply_relations
    has_many :parent_relations, class_name: 'PlyRelation', foreign_key: 'child_id'
    has_many :parents, through: :parent_relations, source: :parent
    has_many :child_relations, class_name: 'PlyRelation', foreign_key: 'parent_id'
    has_many :children, through: :child_relations, source: :child

    after_initialize :set_ply_attributes
    after_initialize :define_ply_scopes

    def self.oldest_last_checked_time
      order('last_checked').first.last_checked
    end

    def self.all
      if self.try(:type).present?
        super.where(otype: self.try(:type))
      else
        super
      end
    end

    def self.ply_name(name)
      self.class.instance_eval do
        define_method(:type) { name }
      end
    end

    # TODO write #children and #parents methods and #self.children and self.parents
    # these will just return an array of each

    def to_param
      oid
    end

    def link
      # TODO make this check env for host
      "https://localhost:3001/invoices/#{self.oid}"
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
      children.pluck(:child_type).uniq.each do |name|
        define_singleton_method(scopify(name)) do
          children.where(otype: name)
        end
      end

      parents.pluck(:parent_type).uniq.each do |name|
        define_singleton_method(scopify(name)) do
          parents.where(otype: name)
        end
      end
    end

    def scopify(name)
      TextHelper.pluralize(name.gsub('__c', '').downcase)
    end
  end # Ply
end # Pliable
