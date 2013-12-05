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
    #
    # get current users geolocation and start the module
    #
    onLoad: (data) ->
      @mapView = new MapView()
      @mapView.moduleId = @id
      $(data.el).append @mapView.render().el

      # GMaps.geolocate
      #   success: (position) =>
      #     # notify subscribers of geo position
      #     Bronson.publish 'map:geoupdate',
      #       lat: position.coords.latitude
      #       lng: position.coords.longitude

      #     @position = position
      #     @start()

    #
    # render the map and wire up events
    #
    onStart: ->
      # create a new instance of gmaps
      map = new GMaps
        el: $('.content', @mapView.el).get(0)
        lat: 37.788086
        lng: -122.401111
        zoom: 13
        scrollwheel: false
        click: (e) ->
          # notify subscribers of new click position
          Bronson.publish 'app:geoupdate',
            lat: e.latLng.ob
            lng: e.latLng.pb
        dragend: (e) ->
          # notify subscribers of new dragged position
          Bronson.publish 'app:geoupdate',
            lat: e.center.ob
            lng: e.center.pb

      Bronson.subscribe 'map:app:addmarker', (data) ->
        map.addMarker
          lat: data.lat
          lng: data.lng

      # # place markers for new instagram photos
      # Bronson.subscribe 'map:instagram:update', (data) =>
      #   map.removeMarkers()
      #   markers = []
      #   data.markers.forEach (item) ->
      #     markers.push
      #       lat: item.get('location').latitude
      #       lng: item.get('location').longitude
      #       details:
      #         id: item.get('id')
      #       click: (e) ->
      #         Bronson.publish 'map:markerselected',
      #         id: e.details.id

      #   map.addMarkers markers

      # # center view on selected photos
      # Bronson.subscribe 'map:instagram:imageselected', (data) =>
      #   map.setCenter data.photo.get('location').latitude,
      #     data.photo.get('location').longitude

    #
    # stop interacting with other modules
    #
    onStop: ->
      Bronson.unsubscribe 'map:instagram:selectmarker'
      Bronson.unsubscribe 'map:instagram:markers'

    #
    # unsubscribe all events and unrender view
    #
    onUnload: ->
      Bronson.unsubscribe 'map'
