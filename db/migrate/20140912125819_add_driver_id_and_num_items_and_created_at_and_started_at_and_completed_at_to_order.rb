class AddDriverIdAndNumItemsAndCreatedAtAndStartedAtAndCompletedAtToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :driver_id, :integer
    add_column :orders, :num_items, :integer
    add_column :orders, :order_created_at, :datetime
    add_column :orders, :order_started_at, :datetime
    add_column :orders, :order_completed_at, :datetime
  end
end
