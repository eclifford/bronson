define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/twitter/views/tweetItemView',
  'text!apps/src/twitter/templates/tweetsTemplate.html'
], ($, _, Backbone, Bronson, TweetItemView, TweetsTemplate) ->
  class TweetsView extends Backbone.View
    moduleId: null
    tagName: 'li'
    className: 'module twitter'
    started: true

    events: ->
      'click .close': 'dispose'
      'click .icon-stop': 'stop'
      'click .icon-play': 'start'

    initialize: ->
      _.bindAll @, 'render'
      @collection.bind 'reset', @render

    render: ->
      $(@el).html(_.template(TweetsTemplate))

      _.each @collection.models, ((item) ->
        @renderItem item
      ), @

      if @started
        $('.icon-play', @el).removeClass('inactive')
        $('.icon-stop', @el).addClass('inactive') 
      else
        $('.icon-stop', @el).removeClass('inactive')
        $('.icon-play', @el).addClass('inactive')        

      @

    stop: ->
      Bronson.Api.stopModule @moduleId
      $('.icon-stop', @el).removeClass('inactive')
      $('.icon-play', @el).addClass('inactive')
      @started = false

    start: ->
      Bronson.Api.startModule @moduleId
      $('.icon-play', @el).removeClass('inactive')
      $('.icon-stop', @el).addClass('inactive')
      @started = true

    renderItem: (item) ->
      tweetItemView = new TweetItemView 
        model: item
      $(@el).append tweetItemView.render().el

    dispose: ->
      @collection.unbind 'change'
      @collection.dispose()
      $(@el).remove()   



