class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name, :null => false, :default => ""
      t.float :price, :default => 0
      t.references :company

      t.timestamps
    end
  end
end
