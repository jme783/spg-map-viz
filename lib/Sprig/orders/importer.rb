module Sprig
  module Orders
    class Importer
      def initialize path
        @path = path
      end

      def import_order_data!
        CSV.foreach(@path, headers: true, return_headers: false) do |row|
          @row = row
          @order = Order.create({
            :latitude => row['latitude'],
            :longitude => row['longitude'],
            :hub_id => row['hub_id'],
            :driver_id => row['driver_id'],
            :num_items => row['num_items'],
            :order_created_at => row['created_at'],
            :order_started_at => row['started_at'],
            :order_completed_at => row['completed_at']
          })
          @order ? (puts "Order with id #{@order.id} successfully added") : (puts "Error adding order with id #{@order.id}")
        end
      end
    end
  end
end
