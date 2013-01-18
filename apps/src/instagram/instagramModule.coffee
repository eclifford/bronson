define [
  'jquery',
  'underscore',
  'backbone',
  'apps/lib/instagram/views/carouselView',
  'apps/lib/instagram/collection/imagesCollection'
], ($, _, Backbone, CarouselView, ImagesCollection) ->
  class InstagramModule extends Bronson.Module
    constructor: (config={}) ->
      @el = config.el

    load: ->
      @imagesCollection = new ImagesCollection()

      @carouselView = new CarouselView
        collection: @imagesCollection
      @carouselView.moduleId = @id

      @imagesCollection.fetch
        data: 
          client_id: "b3481714257943a4974e4e7ba99eb357"
          lat: "37.788086"
          lng: "-122.401111"
        silent: true
        success: =>
          $(@el).append @carouselView.render().el
        
    start: ->
      Bronson.subscribe 'instagram:app:geoupdate', (data) =>
        @imagesCollection.fetch
          data:
            client_id: "b3481714257943a4974e4e7ba99eb357"
            lat: data.latitude
            lng: data.longitude
          silent: false

      super()

    stop: ->
      Bronson.unsubscribe('instagram')
      super()

    unload: ->
      super()
