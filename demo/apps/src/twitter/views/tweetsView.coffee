define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/twitter/views/tweetItemView',
  'text!apps/src/twitter/templates/tweetsTemplate.html'
], ($, _, Backbone, Bronson, TweetItemView, TweetsTemplate) ->
  class TweetsView extends Backbone.View
    tagName: 'li'
    className: 'module twitter'
      
    events: ->
      'click .icon-remove-sign': 'dispose'

    initialize: ->
      @id = Math.random().toString(36).substring(7)
      _.bindAll @, 'render'
      @collection.bind 'reset', @render

    render: ->
      $(@el).html(_.template(TweetsTemplate))

      _.each @collection.models, ((item) ->
        @renderItem item
      ), @

      @

    renderItem: (item) ->
      tweetItemView = new TweetItemView 
        model: item
      $(@el).append tweetItemView.render().el

    dispose: ->
      @collection.unbind 'change'
      @collection.dispose()
      $(@el).remove()   



