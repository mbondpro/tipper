class CreateActs < ActiveRecord::Migration
  def change
    create_table :acts do |t|
      t.references :service
      t.references :treatment
      t.float :cost

      t.timestamps
    end
    add_index :acts, :service_id
    add_index :acts, :treatment_id
  end
end
