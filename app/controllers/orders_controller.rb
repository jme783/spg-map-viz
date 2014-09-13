class OrdersController < ApplicationController
  def find_by_hub
    @orders = Order.where("hub_id = ?", params[:hub_id])
    @orders_hash = Gmaps4rails.build_markers(@orders) do |order, marker|
      marker.lat order.latitude
      marker.lng order.longitude
      marker.title "Order #" + order.id.to_s
      marker.picture({
         :url => view_context.image_path("order-hub-#{order.hub.id.to_s}.png"),
         :width   => 16,
         :height  => 16
      })
    end
      render :json => @orders_hash.to_json
      return false
  end
end
