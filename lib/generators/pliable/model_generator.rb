require "rails/generators/active_record"

module Pliable
  module Generators
    class ModelGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      def self.next_migration_number(path)
        @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i.to_s
      end

      source_root File.expand_path("../templates", __FILE__)

      def add_initializer
        create_file "config/initializers/pliable.rb", "Pliable.configure do |config|
  # define extra scrubbing for ply_name here.  This is for the purpose of making scopes.
  # For instance, if your models ply name is something like 'Invoice__c'
  # you will need to gsub '__c' off the end:
  # config.added_scrubber {|name| name.gsub('__c', '') }
end"
      end

      def generate_ply_and_relation_model
        Rails::Generators.invoke("active_record:model", ["Ply", "--parent", "pliable/ply",  "--no-migration" ])
      end

      def generate_migration
        # TODO only run if migration dosn't exist
        migration_template "migration.rb", "db/migrate/create_plies_and_ply_relations"
      end

      def run_migrations
        unless (ActiveRecord::Base.connection.table_exists?('plies') && (ActiveRecord::Base.connection.table_exists? 'ply_relations'))
          rake("db:migrate db:test:prepare")
        end
      end

    end
  end
end
