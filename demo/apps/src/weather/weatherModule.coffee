#http://api.wunderground.com/api/2d04094a0883bebf/satellite/q/CA/San_Francisco.json

define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/weather/models/weatherModel',
  'apps/lib/weather/views/weatherView'
], ($, _, Backbone, Bronson, WeatherModel, WeatherView) ->
  class WeatherModule extends Bronson.Module
    constructor: (parameters={}) ->
      @el = parameters.el
      super

    initialize: ->
      weatherModel = new WeatherModel()

      @weatherView = new WeatherView 
        model: weatherModel

      weatherModel.url = 'http://api.wunderground.com/api/2d04094a0883bebf/forecast/geolookup/conditions/q/CA/San_Francisco.json?callback=?' 

      weatherModel.fetch
        silent: true
        success: =>
          $(@el).append @weatherView.render().el

      Bronson.Core.subscribe 'WeatherModule', 'geoUpdate', (data) ->
        weatherModel.url = "http://api.wunderground.com/api/2d04094a0883bebf/forecast/geolookup/conditions/q/#{data.latitude},#{data.longitude}.json?callback=?"
        weatherModel.fetch()

      Bronson.Core.subscribe 'WeatherModule', 'dispose', =>
        @dispose()

    dispose: ->
      #super