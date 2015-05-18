class CreateDataTypeTags < ActiveRecord::Migration
  def change
    create_table :data_type_tags do |t|
      t.integer :tag_id
      t.integer :data_type_id

      t.timestamps null: false
    end
  end
end
