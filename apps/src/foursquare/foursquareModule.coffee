define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/foursquare/collection/venuesCollection',
  'apps/lib/foursquare/views/venuesView'
], ($, _, Backbone, Bronson, VenuesCollection, VenuesView) ->
  class FoursquareModule extends Bronson.Module
    constructor: (config={}) ->
      @el = config.el

    load: ->
      @venuesCollection = new VenuesCollection()

      @venuesView = new VenuesView
        moduleId: @id 
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

      super()

    stop: ->
      console.log 'stopping module'
      Bronson.Api.unsubscribe 'foursquaremodule', 'geoUpdate'
      super()

    unload: ->
      super()