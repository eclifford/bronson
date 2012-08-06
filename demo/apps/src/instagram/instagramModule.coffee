define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/instagram/views/carouselView',
  'apps/lib/instagram/collection/imagesCollection'
], ($, _, Backbone, Bronson, CarouselView, ImagesCollection) ->
  class InstagramModule extends Bronson.Module
    constructor: (parameters={}) ->
      @el = parameters.el
      super

    initialize: ->
      @imagesCollection = new ImagesCollection()

      @carouselView = new CarouselView
        collection: @imagesCollection

      @imagesCollection.fetch
        data: 
          client_id: "b3481714257943a4974e4e7ba99eb357"
          lat: "48.858844"
          lng: "2.294351"
        silent: true
        success: =>
          $(@el).append @carouselView.render().el


      Bronson.Api.subscribe 'InstagramModule', 'geoUpdate', (data) =>
        @imagesCollection.fetch
          data:
            client_id: "b3481714257943a4974e4e7ba99eb357"
            lat: data.latitude
            lng: data.longitude
          silent: false

      Bronson.Api.subscribe 'InstagramModule', 'dispose', =>
        #@dispose()

    dispose: ->
      super
