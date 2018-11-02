class AddAlternatesToUser < ActiveRecord::Migration
  def change
    add_column :users, :goal, :float, :default => 0
    add_column :users, :high_commission, :float, :default => 0
  end
end
