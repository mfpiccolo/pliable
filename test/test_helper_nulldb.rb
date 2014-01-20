require "bundler/setup"
require_relative 'test_helper'

require 'active_record/connection_adapters/postgresql_adapter'

ActiveRecord::ConnectionAdapters::NullDBAdapter::TableDefinition.send :include, ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::ColumnMethods

class ActiveRecord::ConnectionAdapters::NullDBAdapter
  def initialize(config={})
    @log            = StringIO.new
    @logger         = Logger.new(@log)
    @last_unique_id = 0
    @tables         = {'schema_info' =>  TableDefinition.new(nil, nil, nil, nil)}
    @indexes        = Hash.new { |hash, key| hash[key] = [] }
    @schema_path    = config.fetch(:schema){ "db/schema.rb" }
    @config         = config.merge(:adapter => :nulldb)
    super(nil, @logger)
    @visitor = Arel::Visitors::ToSql.new self if defined?(Arel::Visitors::ToSql)
  end

  def create_table(table_name, options = {})
    # TODO figure out
    table_definition = ActiveRecord::ConnectionAdapters::TableDefinition.new(self, nil, nil, nil)
    unless options[:id] == false
      table_definition.primary_key(options[:primary_key] || "id")
    end

    yield table_definition if block_given?

    @tables[table_name] = table_definition
  end
end
