window.SprigMap = window.SprigMap || {}
(($, SprigMap) ->
  New = (options) ->
    this.hubs = options.hubs
    this.orders = options.orders
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

