#
# Maps Module
#
# Sample Google maps module
#
define [
  'jquery'
  'bronson'
  'modules/gmaps/views/mapView'
  'vendor/bower_components/gmaps/gmaps'
], ($, Bronson, MapView) ->
  class Gmaps extends Bronson.Module

    # Bronson event mediator
    events:
      'app:addmarker': 'update'

    #
    # get current users geolocation and start the module
    #
    onLoad: (data) ->
      @mapView = new MapView()
      @mapView.moduleId = @id
      $(data.el).append @mapView.render().el

      # create a new instance of gmaps
      @map = new GMaps
        el: $('.content', @mapView.el).get(0)
        lat: 37.788086
        lng: -122.401111
        zoom: 13
        # scrollwheel: false
        click: (e) ->
          # notify subscribers of new click position
          Bronson.publish 'app:geoupdate',
            lat: e.latLng.lat()
            lng: e.latLng.lng()

    #
    # render the map and wire up events
    #
    onStart: ->

    #
    # stop interacting with other modules
    #
    onStop: ->
      Bronson.unsubscribe @id

    #
    # unsubscribe all events and unrender view
    #
    onUnload: ->
      Bronson.unsubscribe @id

    update: (data) ->
      @map.addMarker
        lat: data.lat
        lng: data.lng
      @map.setCenter data.lat, data.lng