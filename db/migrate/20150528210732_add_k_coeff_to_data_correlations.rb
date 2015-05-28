class AddKCoeffToDataCorrelations < ActiveRecord::Migration
  def change
    add_column :data_correlations, :k_coeff, :float
  end
end
