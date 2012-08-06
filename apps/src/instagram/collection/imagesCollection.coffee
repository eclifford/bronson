define [
  'underscore',
  'backbone',
  'apps/lib/instagram/model/imageModel'
], (_, Backbone, ImageModel) ->

  class ImagesCollection extends Backbone.Collection
    model: ImageModel
    url: "https://api.instagram.com/v1/media/search?callback=?",
    
    parse: (response) ->
      return response.data

    dispose: ->
      @reset [], silent: true
      @off()

      Object.freeze? @
      