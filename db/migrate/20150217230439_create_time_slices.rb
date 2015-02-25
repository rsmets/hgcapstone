class CreateTimeSlices < ActiveRecord::Migration
  def change
    create_table :time_slices do |t|
      t.integer :year
      t.bigint :population
      t.bigint :gdp

      t.timestamps null: false
    end
  end
end
