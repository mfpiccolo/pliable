class CreatePliesAndPlyRelations < ActiveRecord::Migration
  def change
    create_table :plies do |t|
        t.integer  :user_id
        t.string   :oid
        t.string   :otype
        t.json     :data
        t.hstore   :ohash
        t.datetime :last_modified
        t.datetime :last_checked

        t.timestamps
    end

    create_table :ply_relations do |t|
      t.integer :parent_id
      t.string :parent_type
      t.integer :child_id
      t.string :child_type

      t.timestamps
    end
  end
end
