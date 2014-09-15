class OrdersController < ApplicationController
  def find
    @orders = Order.where(nil)
    filtering_params(params).each do |key, value|
      @orders = @orders.public_send(key, value) if value.present?
    end
      render :json => build_json(@orders)
      return false
  end

  private

  def filtering_params(params)
    params.slice(:hub_id, :completed_before, :completed_after)
  end

  def build_json orders
    @orders_hash = Gmaps4rails.build_markers(orders) do |order, marker|
      marker.lat order.latitude
      marker.lng order.longitude
      marker.title "Order #" + order.id.to_s
      marker.picture({
         :url => view_context.image_path("order-hub-#{order.hub.id.to_s}.png"),
         :width   => 16,
         :height  => 16
      })
    end
    return @orders_hash.to_json
  end
end
