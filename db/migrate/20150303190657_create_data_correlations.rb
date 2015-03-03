class CreateDataCorrelations < ActiveRecord::Migration
  def change
    create_table :data_correlations do |t|
      t.float :p_coeff
      t.integer :event1_id
      t.integer :event2_id

      t.timestamps null: false
    end
  end
end
