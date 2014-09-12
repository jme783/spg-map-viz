include ActionView::Helpers::OutputSafetyHelper
class MapController < ApplicationController
  def index
    @hubs = Hub.all
    @orders = Order.all
    @hubs_hash = Gmaps4rails.build_markers(@hubs) do |hub, marker|
      marker.lat hub.latitude
      marker.lng hub.longitude
      marker.title "Hub #" + hub.id.to_s
    end
    @orders_hash= Gmaps4rails.build_markers(@orders) do |order, marker|
      marker.lat order.latitude
      marker.lng order.longitude
      marker.title "Order #" + order.id.to_s
      marker.picture({
         :url => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=A|007FFF|000000", # up to you to pass the proper parameters in the url, I guess with a method from device
         :width   => 32,
         :height  => 32
      })
    end

  end
end
