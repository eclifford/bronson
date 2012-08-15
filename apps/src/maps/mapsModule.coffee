#http://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&sensor=SET_TO_TRUE_OR_FALSE
define [
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/maps/views/mapView'
], (_, Backbone, Bronson, MapView) ->
  class MapModule extends Bronson.Module
    constructor: (config={}) ->
      @el = config .el

    load: ->
      mapView = new MapView()
      mapView.moduleId = @id
      $(@el).append mapView.render().el

    start: ->
      super()

    stop: ->
      Bronson.Api.unsubscribeAll @id
      super()

    unload: ->
      super()