class AddHubIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :hub_id, :integer
  end
end
