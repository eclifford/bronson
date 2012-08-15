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
    constructor: (config={}) ->
      @el = config.el

    load: ->
      @weatherModel = new WeatherModel()

      @weatherView = new WeatherView 
        model: @weatherModel
      @weatherView.moduleId = @id

      @weatherModel.url = 'http://api.wunderground.com/api/2d04094a0883bebf/forecast/geolookup/conditions/q/Japan/Tokyo.json?callback=?' 

      @weatherModel.fetch
        silent: true
        success: =>
          $(@el).append @weatherView.render().el

    start: ->
      Bronson.Api.subscribe @id, 'geoUpdate', (data) =>
        @weatherModel.url = "http://api.wunderground.com/api/2d04094a0883bebf/forecast/geolookup/conditions/q/#{data.latitude},#{data.longitude}.json?callback=?"
        @weatherModel.fetch()
      super()

    stop: ->
      Bronson.Api.unsubscribeAll @id
      super()

    unload: ->
      super()