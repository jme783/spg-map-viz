window.SprigMap = window.SprigMap || {}
(($, SprigMap) ->
  New = (options) ->
    this.hubs = options.hubs
    this.orders = options.orders
    this.handler = Gmaps.build('Google')
    # Style Google Maps
    this.style_array = [
      {
        stylers: [visibility: "off"]
      }
      {
        featureType: "road"
        stylers: [
          {
            visibility: "on"
          }
          {
            color: "#ffffff"
          }
        ]
      }
      {
        featureType: "road.arterial"
        stylers: [
          {
            visibility: "on"
          }
          {
            color: "#fee379"
          }
        ]
      }
      {
        featureType: "road.highway"
        stylers: [
          {
            visibility: "on"
          }
          {
            color: "#fee379"
          }
        ]
      }
      {
        featureType: "landscape"
        stylers: [
          {
            visibility: "on"
          }
          {
            color: "#f3f4f4"
          }
        ]
      }
      {
        featureType: "water"
        stylers: [
          {
            visibility: "on"
          }
          {
            color: "#7fc8ed"
          }
        ]
      }
      {
        featureType: "road"
        elementType: "labels"
        stylers: [visibility: "off"]
      }
      {
        featureType: "poi.park"
        elementType: "geometry.fill"
        stylers: [
          {
            visibility: "on"
          }
          {
            color: "#83cead"
          }
        ]
      }
      {
        elementType: "labels"
        stylers: [visibility: "off"]
      }
      {
        featureType: "landscape.man_made"
        elementType: "geometry"
        stylers: [
          {
            weight: 0.9
          }
          {
            visibility: "off"
          }
        ]
      }
    ]
    this

  SprigMap.New = New

  New::bind = ->
    this.initializeMap()

  New::initializeMap = ->
    self = this
    self.handler.buildMap
      provider:
        center: new google.maps.LatLng(37.7833, -122.4167)
        zoom: 13
        styles: self.style_array

      internal:
        id: "map"
    , ->
      console.log self
      self.addHubMapMarkers self.hubs


  New::addHubMapMarkers = (hash) ->
    handler = this.handler
    markers = handler.addMarkers(hash)
    handler.bounds.extendWith markers
    handler.fitMapToBounds()
    this.loadHubOrders(markers)

  New::addOrderMapMarkers = (hash) ->
    handler = this.handler
    markers = handler.addMarkers(hash)
    handler.bounds.extendWith markers

  New::loadHubOrders = (hub_markers) ->
     self = this
     i = 0
     while i < hub_markers.length
       marker = hub_markers[i].serviceObject
       google.maps.event.addListener marker, "click", ->
        marker_id = this.title.match(/\d+/)[0]
        $.ajax
          url: "/orders"
          data:
            hub_id: marker_id

          success: (response) ->
            self.addOrderMapMarkers(response)
          error: (xhr) ->
            console.log(xhr)
       ++i
     return

)(jQuery, SprigMap)

