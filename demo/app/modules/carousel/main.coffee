define [
  'jquery'
  'underscore'
  'backbone'
  'marionette'
  'modules/carousel/collections/photosCollection'
  'modules/carousel/views/carouselView'
], ($, _, Backbone, Marionette, PhotosCollection, CarouselView) ->
  class CarouselModule extends Bronson.Module
    onLoad: (data) ->
      App = new Marionette.Application()
      @photos = new PhotosCollection()

      carouselView = new CarouselView
        collection: @photos

      carouselView.moduleId = @id

      @photos.fetch
        data:
          client_id: "b3481714257943a4974e4e7ba99eb357"
          lat: "37.788086"
          lng: "-122.401111"
          count: 4
        silent: true
        success: =>
          $(data.el).append carouselView.render().el
        

    onStart: ->
      Bronson.subscribe "#{@id}:app:geoupdate", (data) =>
        @photos.fetch
          data:
            client_id: "b3481714257943a4974e4e7ba99eb357"
            lat: data.lat
            lng: data.lng
            count: 4
          silent: false

    onStop: ->
      Bronson.unsubscribe @id

    onUnload: ->
