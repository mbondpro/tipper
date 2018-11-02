class CreateTreatments < ActiveRecord::Migration
  def change
    create_table :treatments do |t|
      t.float :cost, :default => 0
      t.float :commission, :default => 0
      t.date :date
      t.references :customer
      t.references :service

      t.timestamps
    end
  end
end
