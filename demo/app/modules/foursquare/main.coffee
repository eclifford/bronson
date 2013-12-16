define [
  'marionette'
  'modules/foursquare/collections/venuesCollection'
  'modules/foursquare/views/venuesView'
], (Marionette, VenuesCollection, VenuesView) ->
  class Foursquare extends Bronson.Module
    onLoad: (data) ->
      @venuesCollection = new VenuesCollection()
      venuesView = new VenuesView
        collection: @venuesCollection
      venuesView.moduleId = @id
      
      @venuesCollection.fetch
        data:
          ll: '37.788086, -122.401111'
          oauth_token: 'O4KTMAIQA3K40AYAU522GP0ILLUY2SVSIH54WSAAGNCOCM1Y'
          v: '20120805'
          limit: 5
          section: 'food'
        silent: true
        success: =>
          $(data.el).append venuesView.render().el

    onStart: ->
      Bronson.subscribe "#{@id}:app:geoupdate", (data) =>
        @venuesCollection.fetch
          data:
            ll: "#{data.lat},#{data.lng}"
            oauth_token: 'O4KTMAIQA3K40AYAU522GP0ILLUY2SVSIH54WSAAGNCOCM1Y'
            v: '20120805'
            limit: 5
            section: 'food'

    onStop: ->
      Bronson.unsubscribe @id

    onUnload: ->
