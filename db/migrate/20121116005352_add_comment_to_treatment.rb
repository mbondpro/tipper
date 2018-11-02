class AddCommentToTreatment < ActiveRecord::Migration
  def change
    add_column :treatments, :comment, :text
  end
end
