class AddTipToTreatment < ActiveRecord::Migration
  def change
    add_column :treatments, :tip, :float, null: false, default: 0
  end
end
