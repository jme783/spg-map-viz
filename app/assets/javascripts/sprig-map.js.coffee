window.SprigMap = window.SprigMap || {}
(($, SprigMap) ->
  New = (options) ->
    this.hubs = options.hubs
    this.orders = options.orders
    this.handler = Gmaps.build('Google')
    this.hubChecks = options.hubChecks
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
    this.initializeDatePicker()
    this.hubCheckBoxChange()

  New::initializeMap = ->
    self = this
    self.handler.buildMap
      provider:
        center: new google.maps.LatLng(37.7833, -122.4167)
        zoom: 14
        styles: self.style_array

      internal:
        id: "map"
    , ->
      self.addHubMapMarkers self.hubs

  New::initializeDatePicker = ->
    # implementation of disabled form fields
    nowTemp = new Date()
    now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)
    startDate = $("#dp4").fdatepicker(
      format: "mm/dd/yyyy"
      onRender: (date) ->
        if parseInt(date.valueOf()) > parseInt(now.valueOf()) 
          return "disabled"
    ).on("changeDate", (ev) ->
      if parseInt(ev.date.valueOf()) > parseInt(endDate.date.valueOf())
        newDate = new Date(ev.date)
        newDate.setDate newDate.getDate() + 1
        endDate.update newDate
      startDate.hide()
      $("#dp5")[0].focus()
      return
    ).data("datepicker")
    endDate = $("#dp5").fdatepicker(
      format: "mm/dd/yyyy"
      onRender: (date) ->
        if parseInt(date.valueOf()) <= parseInt(startDate.date.valueOf())
          return "disabled"
    ).on("changeDate", (ev) ->
      endDate.hide()
      return
    ).data("datepicker")

  New::addHubMapMarkers = (hash) ->
    handler = this.handler
    markers = handler.addMarkers(hash, {opacity: 1, zIndex: 10, clickable: false})
    handler.bounds.extendWith markers

  New::addOrderMapMarkers = (hash, hub_id) ->
    handler = this.handler
    markers = handler.addMarkers(hash, {zIndex: 1})
    # Attach the markers to the SprigMap opject
    markersNameVariable = "markersForHub" + hub_id
    if !SprigMap[markersNameVariable]
      SprigMap[markersNameVariable] = markers
    # Bound the markers to the map
    handler.bounds.extendWith markers
    handler.fitMapToBounds()
    $(".ajax-loader").hide()


   New::loadOrders = (hub_id) ->
    $(".ajax-loader").show()
    self = this
    $.ajax
      url: "/orders"
      data:
        hub_id: hub_id

      success: (response) ->
        self.addOrderMapMarkers(response, hub_id)
      error: (xhr) ->
        console.log(xhr)

   New::hubCheckBoxChange = ->
     self = this
     self.hubChecks.change ->
       hub_id = this.id.match(/\d+/)[0]
       hub_markers = "markersForHub" + hub_id
       if this.checked
         # Only load orders from the DB if they haven't been loaded yet
         if SprigMap[hub_markers]
           j = 0
           while j < SprigMap[hub_markers].length
             marker = SprigMap[hub_markers][j].serviceObject
             marker.setVisible(true)
             ++j
         else
           self.loadOrders(hub_id)
       else
         i = 0
         while i < SprigMap[hub_markers].length
           marker = SprigMap[hub_markers][i].serviceObject
           marker.setVisible(false)
           ++i

)(jQuery, SprigMap)

