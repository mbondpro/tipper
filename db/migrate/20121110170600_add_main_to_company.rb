class AddMainToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :main, :boolean, :null => false, :default => false
  end
end
