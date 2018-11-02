class AddDataToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :phone, :string
    add_column :customers, :email, :string
  end
end
