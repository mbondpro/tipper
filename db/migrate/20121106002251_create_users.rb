class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false, :default => ""
      t.string :username, :null => false, :default => ""
      t.float :commission_rate, :default => 0

      t.timestamps
    end
  end
end
