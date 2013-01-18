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

    load: ->
      @tweetsCollection = new TweetsCollection()

      tweetView = new TweetsView 
        collection: @tweetsCollection
      tweetView.moduleId = @id

      @tweetsCollection.fetch
        data:
          geocode: "37.788086,-122.401111,5mi"
          rpp: 4
        silent: true
        success: =>
          $(@el).append tweetView.render().el

    start: ->
      Bronson.subscribe 'twitter:app:geoupdate', (data) =>
        @tweetsCollection.fetch
          data: 
            geocode: "#{data.latitude},#{data.longitude},1mi"
      super()
    stop: ->
      Bronson.unsubscribe 'twitter'
      super()
      
    unload: ->
      super()