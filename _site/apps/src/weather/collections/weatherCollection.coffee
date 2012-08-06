define [
  'underscore',
  'backbone',
  'apps/lib/weather/model/weatherModel'
], (_, Backbone, WeatherModel) ->

  class WeatherCollection extends Backbone.Collection
    model: WeatherModel
    url: "http://api.wunderground.com/api/2d04094a0883bebf/geolookup/forecast/q/",
    
    dispose: ->
      @reset [], silent: true
      @off()

      Object.freeze? @