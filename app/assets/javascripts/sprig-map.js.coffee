window.SprigMap = window.SprigMap || {}
(($, SprigMap) ->
  New = (options) ->
    this.hubs = options.hubs
    this.orders = options.orders
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
    handler = Gmaps.build('Google')
    handler.buildMap
      provider:
        center: new google.maps.LatLng(37.7833, -122.4167)
        zoom: 13
        styles: this.style_array

      internal:
        id: "map"
    , ->
      self.addMapMarkers handler, self.hubs
      self.addMapMarkers handler, self.orders

  New::addMapMarkers = (handler, hash) ->
    markers = handler.addMarkers(hash)
    handler.bounds.extendWith markers
    handler.fitMapToBounds()

)(jQuery, SprigMap)

