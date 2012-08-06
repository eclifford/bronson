define [
  'underscore',
  'backbone'
], (_, Backbone) ->
  class WeatherModel extends Backbone.Model

    dispose: ->
      @off()

      Object.freeze? @