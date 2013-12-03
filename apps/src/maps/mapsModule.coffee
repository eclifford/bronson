#http://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&sensor=SET_TO_TRUE_OR_FALSE
define [
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/maps/views/mapView'
  'javascripts/vendor/gmaps'
], (_, Backbone, Bronson, MapView) ->
  class MapModule extends Bronson.Module
    constructor: (config={}) ->
      @el = config.el

    onLoad: ->
      console.log @el
      mapView = new MapView()
      mapView.moduleId = @id
      console.log @id
      $(@el).append mapView.render().el

      @map = new GMaps
        el: $('.map', mapView.el).get(0)
        lat: 37
        lng: -122
        zoom: 13
        scrollwheel: false

    onStart: ->
      Bronson.subscribe 'maps:app:geoupdate', (data) =>
        @map.setCenter data.latitude, data.longitude

    onStop: ->
      alert 'stopped!'
      Bronson.unsubscribe 'maps'

    onUnload: ->
