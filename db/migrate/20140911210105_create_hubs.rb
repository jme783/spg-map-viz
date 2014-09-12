class CreateHubs < ActiveRecord::Migration
  def change
    create_table :hubs do |t|
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
