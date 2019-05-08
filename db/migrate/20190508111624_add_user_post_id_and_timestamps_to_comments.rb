class AddUserPostIdAndTimestampsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :integer
    add_column :comments, :post_id, :integer
    add_column :comments, :created_at, :datetime
    add_column :comments, :updated_at, :datetime
  end
end
