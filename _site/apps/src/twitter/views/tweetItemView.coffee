define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/twitter/templates/tweetTemplate.html'
], ($, _, Backbone, Bronson, TweetItemTemplate) ->
  class TweetItemView extends Backbone.View
    events: 
      "click": 'notify'

    initialize: ->

    notify: ->
      if @model.get('geo')?
        coords = 
          title: @model.get('from_user')
          latitude: @model.get('geo').coordinates[0]
          longitude: @model.get('geo').coordinates[1]

        Bronson.Api.publish 'addMarker', coords
    render: ->
      $(@el).html(_.template(TweetItemTemplate, @model.toJSON()))
      @