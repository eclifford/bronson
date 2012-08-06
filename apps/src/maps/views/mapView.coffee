define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/maps/templates/mapTemplate.html',
  'async!http://maps.googleapis.com/maps/api/js?key=AIzaSyDTB9ap7VN6CRrMWaAS2cKwctgjn-_l_oA&sensor=false'
], ($, _, Backbone, Bronson, MapTemplate) ->
  class MapView extends Backbone.View
    tagName: 'li'
    className: 'module maps'

    initialize: ->
      @id = Math.random().toString(36).substring(7)

      Bronson.Core.subscribe 'MapModule', 'geoUpdate', (data) =>
        panLocation = new google.maps.LatLng(data.latitude, data.longitude)
        @map.panTo(panLocation)

    events: ->
      'click .close': 'dispose'

    render: ->
      
      mapOptions =
        zoom: 8
        center: new google.maps.LatLng(34.397, 137.644)
        mapTypeId: google.maps.MapTypeId.ROADMAP  


      
      @map = new google.maps.Map $(@el).get(0), mapOptions

      google.maps.event.addListener(@map, 'click', (event) => 
        console.log 'test'
        #center = @map.getCenter()
        # console.log center, 'center'
        coord =
          latitude: event.latLng.Ya
          longitude: event.latLng.Za
        # console.log coord
        Bronson.Core.publish 'geoUpdate', coord
      )

      $(@el).prepend(_.template(MapTemplate, {id: @id}))
      @

    dispose: ->
      #Bronson.Core.publish 'dispose'
      @collection.unbind 'change'
      @collection.dispose()
      $(@el).remove()



