class AddUserToTreatment < ActiveRecord::Migration
  def change
    add_column :treatments, :user_id, :integer
  end
end
