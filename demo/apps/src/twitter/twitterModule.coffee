define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/twitter/views/tweetsView',
  'apps/lib/twitter/collection/tweetsCollection'
], ($, _, Backbone, Bronson, TweetsView, TweetsCollection) ->
  class TwitterModule extends Bronson.Module
    constructor: (parameters={}) ->
      @el = parameters.el
      super

    initialize: ->
      tweetsCollection = new TweetsCollection()

      tweetView = new TweetsView 
        el: @el
        collection: tweetsCollection

      tweetsCollection.fetch
        data:
          geocode: "37.781157,-122.398720,1mi"

      Bronson.Core.subscribe 'TwitterModule', 'geoUpdate', (data) ->
        tweetsCollection.fetch
          data: 
            geocode: "#{data.latitude},#{data.longitude},1mi"


    dispose: ->