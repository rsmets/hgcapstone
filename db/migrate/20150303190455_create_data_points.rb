class CreateDataPoints < ActiveRecord::Migration
  def change
    create_table :data_points do |t|
      t.integer :year
      t.float :value
      t.integer :event_type_id

      t.timestamps null: false
    end
  end
end
