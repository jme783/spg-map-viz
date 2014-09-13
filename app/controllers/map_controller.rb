include ActionView::Helpers::OutputSafetyHelper
class MapController < ApplicationController
  def index
    @hubs = Hub.all
    @orders = Order.all
    @hubs_hash = Gmaps4rails.build_markers(@hubs) do |hub, marker|
      marker.lat hub.latitude
      marker.lng hub.longitude
      marker.title "Hub #" + hub.id.to_s
      marker.picture({
         :url => view_context.image_path("hub-#{hub.id.to_s}.png"),
         :width   => 32,
         :height  => 32
      })
      marker.json({ :id => hub.id})
    end

  end
end
