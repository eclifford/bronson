define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/maps/templates/mapTemplate.html',
  'async!http://maps.googleapis.com/maps/api/js?key=AIzaSyDTB9ap7VN6CRrMWaAS2cKwctgjn-_l_oA&sensor=false'
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
      Bronson.Api.subscribe @moduleId, 'geoUpdate', (data) =>
        panLocation = new google.maps.LatLng(data.latitude, data.longitude)
        @map.panTo(panLocation)

      Bronson.Api.subscribe @moduleId, 'addMarker', (data) =>
        latlng = new google.maps.LatLng(data.latitude, data.longitude)
        marker = new google.maps.Marker
          animation: google.maps.Animation.DROP,
          position: latlng
          map: @map
        @map.panTo latlng

      mapOptions =
        zoom: 14
        center: new google.maps.LatLng(35.689488, 139.691706)
        mapTypeId: google.maps.MapTypeId.ROADMAP  
        mapTypeControl: false

      $(@el).prepend(_.template(MapTemplate, null))
      @map = new google.maps.Map $('.map', @el).get(0), mapOptions

      google.maps.event.addListener(@map, 'click', (event) => 
        coord =
          latitude: event.latLng.Xa
          longitude: event.latLng.Ya
        Bronson.Core.publish 'geoUpdate', coord
      )

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
      Bronson.Api.unloadModule @moduleId
      @collection.unbind 'change'
      @collection.dispose()
      $(@el).remove()



