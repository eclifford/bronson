#http://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&sensor=SET_TO_TRUE_OR_FALSE
define [
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/maps/views/mapView'
], (_, Backbone, Bronson, MapView) ->
  class MapModule extends Bronson.Module
    constructor: (parameters={}) ->
      @id = Math.random().toString(36).substring(7)
      @el = parameters.el
      super

    initialize: ->
      mapView = new MapView()
      $(@el).append mapView.render().el

    dispose: ->