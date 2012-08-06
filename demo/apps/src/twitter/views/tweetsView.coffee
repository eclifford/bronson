define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/twitter/views/tweetItemView',
  'text!apps/src/twitter/templates/tweetsTemplate.html'
], ($, _, Backbone, Bronson, TweetItemView, TweetsTemplate) ->
  class TweetsView extends Backbone.View

    initialize: ->
      @id = Math.random().toString(36).substring(7)
      _.bindAll @, 'render'
      @collection.bind 'reset', @render

    render: ->
      if $(".#{@id}", @el).length == 0   
        $(@el).append(_.template(TweetsTemplate, {id: @id}))
      else
        $(".#{@id}", @el).html(_.template(TweetsTemplate, {id: @id}))

      _.each @collection.models, ((item) ->
        @renderItem item
      ), @

      @

    renderItem: (item) ->
      tweetItemView = new TweetItemView 
        model: item
      $('.module.twitter', @el).append tweetItemView.render().el



