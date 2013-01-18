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
        collection: @venuesCollection 
      @venuesView.moduleId = @id

      @venuesCollection.fetch
        data:
          ll: '37.788086, -122.401111'
          oauth_token: 'O4KTMAIQA3K40AYAU522GP0ILLUY2SVSIH54WSAAGNCOCM1Y'
          v: '20120805'
          limit: 5
          section: 'food'
        silent: true
        success: =>
          $(@el).append @venuesView.render().el

    start: ->
      Bronson.subscribe 'foursqaure:app:geoupdate', (data) =>
        @venuesCollection.fetch
          data:
            ll: "#{data.latitude},#{data.longitude}"
            oauth_token: 'O4KTMAIQA3K40AYAU522GP0ILLUY2SVSIH54WSAAGNCOCM1Y'
            v: '20120805'
            limit: 5
            section: 'food'

      super()

    stop: ->
      Bronson.unsubscribe 'foursqaure'
      super()

    unload: ->
      super()