define [
  'underscore'
  'backbone'
], (_, Backbone) ->
  class PhotosCollection extends Backbone.Collection
    url: 'https://api.instagram.com/v1/media/search?callback=?'

    parse: (response) ->
      return response.data

