define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/maps/templates/mapTemplate.html'
], ($, _, Backbone, Bronson, MapTemplate) ->
  class MapView extends Backbone.View
    moduleId: null
    tagName: 'li'
    className: 'module maps'
    started: true

    initialize: ->

    events: ->
      'click .close': 'dispose'
      'click .icon-stop': 'stop'
      'click .icon-play': 'start'

    render: -> 
      # Bronson.subscribe 'maps:app:geoupdate', (data) =>
      #   panLocation = new google.maps.LatLng(data.latitude, data.longitude)
      #   @map.panTo(panLocation)

      Bronson.subscribe 'maps:app:addmarker', (data) =>
        latlng = new google.maps.LatLng(data.latitude, data.longitude)
        marker = new google.maps.Marker
          animation: google.maps.Animation.DROP,
          position: latlng
          map: @map
        @map.panTo latlng

      $(@el).prepend(_.template(MapTemplate, null))

  
      if @started
        $('.icon-play', @el).removeClass('inactive')
        $('.icon-stop', @el).addClass('inactive') 
      else
        $('.icon-stop', @el).removeClass('inactive')
        $('.icon-play', @el).addClass('inactive')        

      @

    stop: ->
      console.log @moduleId
      Bronson.stop @moduleId
      $('.icon-stop', @el).removeClass('inactive')
      $('.icon-play', @el).addClass('inactive')
      @started = false

    start: ->
      Bronson.start @moduleId
      $('.icon-play', @el).removeClass('inactive')
      $('.icon-stop', @el).addClass('inactive')
      @started = true

    dispose: ->
      Bronson.unload @moduleId
      $(@el).remove()



