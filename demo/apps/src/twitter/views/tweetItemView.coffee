define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/twitter/templates/tweetTemplate.html'
], ($, _, Backbone, Bronson, TweetItemTemplate) ->
  class TweetItemView extends Backbone.View
    initialize: ->

    render: ->
      $(@el).html(_.template(TweetItemTemplate, @model.toJSON()))
      @