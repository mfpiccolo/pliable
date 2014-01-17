require "rails/generators/active_record"

module Pliable
  module Generators
    class ModelGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      def self.next_migration_number(path)
          @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i.to_s
      end

      source_root File.expand_path("../templates", __FILE__)

      def generate_migration
        # TODO only run if migration dosn't exist
        migration_template "migration.rb", "db/migrate/create_plies_and_ply_relations"
      end

      def generate_ply_and_relation_model
        Rails::Generators.invoke("active_record:model", ["Ply", "--no-migration" ])
        Rails::Generators.invoke("active_record:model", ["PlyRelation", "--no-migration" ])
      end

      def add_ply_content
        content = <<-CONTENT
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
        CONTENT

        content = content.split("\n").map { |line| "  " * 0 + line } .join("\n") << "\n"

        inject_into_class("app/models/ply.rb", "Ply", content)
      end

      def add_ply_relation_content
        content = <<-CONTENT
  belongs_to :parent, class_name: 'Ply'
  belongs_to :child, class_name: 'Ply'
        CONTENT

        content = content.split("\n").map { |line| "  " * 0 + line } .join("\n") << "\n"

        inject_into_class("app/models/ply_relation.rb", "PlyRelation", content)
        @_invocations.first[1].pop
      end

      def run_migrations
        unless (ActiveRecord::Base.connection.table_exists?('plies') && (ActiveRecord::Base.connection.table_exists? 'ply_relations'))
          rake("db:migrate db:test:prepare")
        end
      end

    end
  end
end
