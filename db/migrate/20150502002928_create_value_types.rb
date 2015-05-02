class CreateValueTypes < ActiveRecord::Migration
  def change
    create_table :value_types do |t|
      t.string :name	
      t.timestamps null: false
    end
  end
end
