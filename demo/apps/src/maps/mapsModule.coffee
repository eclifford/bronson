#http://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&sensor=SET_TO_TRUE_OR_FALSE
define [
  'underscore',
  'backbone',
  'bronson',
  'async!http://maps.googleapis.com/maps/api/js?key=AIzaSyDTB9ap7VN6CRrMWaAS2cKwctgjn-_l_oA&sensor=false'
], (_, Backbone, Bronson) ->
  class MapModule extends Bronson.Module
    constructor: (parameters={}) ->
      @id = Math.random().toString(36).substring(7)
      @el = parameters.el
      super

    initialize: ->
      mapOptions =
        zoom: 8
        center: new google.maps.LatLng(-34.397, 150.644)
        mapTypeId: google.maps.MapTypeId.ROADMAP
      item = $("<div class='module maps #{@id}'></div>")
      $(@el).append(item)
      @map = new google.maps.Map $(item).get(0), mapOptions

      Bronson.Core.subscribe 'MapModule', 'geoUpdate', (data) =>
        panLocation = new google.maps.LatLng(data.latitude, data.longitude)
        @map.panTo(panLocation)

    dispose: ->