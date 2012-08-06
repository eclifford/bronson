#http://api.wunderground.com/api/2d04094a0883bebf/satellite/q/CA/San_Francisco.json

define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/weather/templates/weatherTemplate.html'
], ($, _, Backbone, Bronson, WeatherTemplate) ->
  class WeatherModule extends Bronson.Module
    constructor: (parameters={}) ->
      @el = parameters.el
      super

    initialize: ->
      $.ajax
        url: "http://api.wunderground.com/api/2d04094a0883bebf/geolookup/conditions/q/IA/Cedar_Rapids.json"
        dataType: "jsonp"
        success: (parsed_json) =>
          location = parsed_json["location"]["city"]
          temp_f = parsed_json["current_observation"]["temp_f"]
          $(@el).append(_.template(WeatherTemplate, parsed_json))         


    dispose: ->