class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
