class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name, :null => false, :default => ""

      t.timestamps
    end
  end
end
