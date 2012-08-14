define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/foursquare/collection/venuesCollection',
  'apps/lib/foursquare/views/venuesView'
], ($, _, Backbone, Bronson, VenuesCollection, VenuesView) ->
  class FoursquareModule extends Bronson.Module
    constructor: (parameters={}) ->
      @el = parameters.el
      super

    load: ->
      @venuesCollection = new VenuesCollection()

      @venuesView = new VenuesView 
        collection: @venuesCollection 

      @venuesCollection.fetch
        data:
          ll: '35.689488, 139.691706'
          oauth_token: 'O4KTMAIQA3K40AYAU522GP0ILLUY2SVSIH54WSAAGNCOCM1Y'
          v: '20120805'
          limit: 5
          section: 'food'
        silent: true
        success: =>
          $(@el).append @venuesView.render().el

    start: ->
      Bronson.Api.subscribe 'foursquaremodule', 'geoUpdate', (data) =>
        @venuesCollection.fetch
          data:
            ll: "#{data.latitude},#{data.longitude}"
            oauth_token: 'O4KTMAIQA3K40AYAU522GP0ILLUY2SVSIH54WSAAGNCOCM1Y'
            v: '20120805'
            limit: 5
            section: 'food'

    stop: ->
      Bronson.Api.unsubscribe 'foursquaremodule', 'geoUpdate'

    unload: ->