define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/weather/templates/weatherTemplate.html'
], ($, _, Backbone, Bronson, WeatherTemplate) ->
  class WeatherView extends Backbone.View
    moduleId: null
    tagName: 'li'
    className: 'module weather'
    started: true

    events: ->
      'click .close': 'dispose'
      'click .icon-stop': 'stop'
      'click .icon-play': 'start'

    initialize: ->
      _.bindAll @, 'render'
      @model.bind 'change', @render

    render: ->
      $(@el).html(_.template(WeatherTemplate, @model.toJSON()))

      if @started
        $('.icon-play', @el).removeClass('inactive')
        $('.icon-stop', @el).addClass('inactive') 
      else
        $('.icon-stop', @el).removeClass('inactive')
        $('.icon-play', @el).addClass('inactive')        

      @

    stop: ->
      Bronson.Api.stopModule @moduleId
      $('.icon-stop', @el).removeClass('inactive')
      $('.icon-play', @el).addClass('inactive')
      @started = false

    start: ->
      Bronson.Api.startModule @moduleId
      $('.icon-play', @el).removeClass('inactive')
      $('.icon-stop', @el).addClass('inactive')
      @started = true

    dispose: ->
      return if @disposed
      Bronson.Api.unloadModule @moduleId
      @disposed = true
      @model.unbind 'change'
      @model.dispose()
      $(@el).remove()



