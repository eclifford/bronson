define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/weather/templates/weatherTemplate.html'
], ($, _, Backbone, Bronson, WeatherTemplate) ->
  class WeatherView extends Backbone.View
    tagName: 'li'
    className: 'module weather'

    events: ->
      'click .close': 'dispose'
      
    initialize: ->
      @id = Math.random().toString(36).substring(7)
      _.bindAll @, 'render'
      @model.bind 'change', @render

    render: ->
      $(@el).html(_.template(WeatherTemplate, @model.toJSON()))
      @

    dispose: ->
      console.log 'dispose'
      return if @disposed
      @disposed = true
      Bronson.Core.publish 'dispose'
      @model.unbind 'change'
      @model.dispose()
      $(@el).remove()



