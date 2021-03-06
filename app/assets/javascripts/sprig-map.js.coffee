window.SprigMap = window.SprigMap || {}
(($, SprigMap) ->
  New = (options) ->
    this.hubs = options.hubs
    this.orders = options.orders
    this.hubChecks = options.hubChecks
    this.handler = Gmaps.build('Google')
    this.dateFields = $('.dp-field')
    this.activeHubs = []
    window.markersArray = []
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
    this.showOrderClick()

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
    self = this
    # implementation of disabled form fields
    firstOrder = new Date("March 4, 2014 01:46:08")
    lastOrder = new Date("April 1, 2014 04:44:18")
    firstOrderFormatted = new Date(firstOrder.getFullYear(), firstOrder.getMonth(), firstOrder.getDate(), 0, 0, 0, 0)
    lastOrderFormatted = new Date(lastOrder.getFullYear(), lastOrder.getMonth(), lastOrder.getDate(), 0, 0, 0, 0)
    startDate = $("#dp4").fdatepicker(
      format: "yyyy-mm-dd"
      onRender: (date) ->
        if parseInt(date.valueOf()) > parseInt(lastOrderFormatted.valueOf()) || parseInt(date.valueOf()) < parseInt(firstOrderFormatted.valueOf())
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
      format: "yyyy-mm-dd"
      onRender: (date) ->
        if parseInt(date.valueOf()) <= parseInt(startDate.date.valueOf()) || parseInt(date.valueOf()) > parseInt(lastOrderFormatted.valueOf()) || parseInt(date.valueOf()) < parseInt(firstOrderFormatted.valueOf())
          return "disabled"
    ).on("changeDate", (ev) ->
      endDate.hide()
      return
    ).data("datepicker")

  New::addHubMapMarkers = (hash) ->
    handler = this.handler
    markers = handler.addMarkers(hash, {opacity: 1, zIndex: 10, clickable: false})
    handler.bounds.extendWith markers
    #Show some Orders on the map by default
    $('#hub-1').prop('checked','checked')
    this.activeHubs.push("1")
    $('.search').click()


  New::addOrderMapMarkers = (hash) ->
    self = this
    i = 0
    handler = self.handler
    markers = handler.addMarkers(hash, {zIndex: 1})
    while i < markers.length
      marker = markers[i].serviceObject
      window.markersArray.push(marker)
      ++i
    # Bound the markers to the map
    handler.bounds.extendWith markers
    handler.fitMapToBounds()
    $(".ajax-loader").fadeOut(100)


   New::loadOrders = () ->
    before_date = $('#dp4').val()
    after_date = $('#dp5').val()
    $(".ajax-loader").fadeIn(100)
    self = this
    $.ajax
      url: "/orders"
      data:
        hub_ids: (if self.activeHubs.length > 0 then self.activeHubs.join(",") else "0"),
        completed_before: $('#dp5').val() ,
        completed_after: $('#dp4').val(),
        num_items: (if $('.number-items-select').val() == "0" then "" else $('.number-items-select').val())

      success: (response) ->
        if response.length != 0
          self.addOrderMapMarkers(response)
        else
          alertHTML = '<div data-alert class="map-alert alert-box warning">Sorry, your search did not match any orders. Please try again</div>'
          $(alertHTML).appendTo("body")
          setTimeout ->
            $('.map-alert').fadeOut(300)
          , 2000
          $(".ajax-loader").hide()
      error: (xhr) ->
        console.log(xhr)


   New::showOrderClick = ->
     self = this
     $('a.search').click (e) ->
       e.preventDefault()
       self.clearMarkers()
       self.loadOrders()

   New::hubCheckBoxChange = ->
     self = this
     self.hubChecks.change ->
       hub_id = this.id.match(/\d+/)[0]
       if this.checked
         # Add hub to active list
         self.activeHubs.push(hub_id)
       else
         # Remove hub from active list
         index = self.activeHubs.indexOf(hub_id)
         if index > -1
           self.activeHubs.splice(index, 1)

    New::clearMarkers = ->
      self = this
      i = 0
      while i < window.markersArray.length
        window.markersArray[i].setVisible false
        ++i
      window.markersArray.length = 0

)(jQuery, SprigMap)

