define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/foursquare/templates/venueTemplate.html'
], ($, _, Backbone, Bronson, VenueItemTemplate) ->
  class VenueItemView extends Backbone.View
    events: 
      "click": 'notify'

    initialize: ->

    notify: ->

      coords = 
        title: @model.get('name')
        latitude: @model.get('location').lat
        longitude: @model.get('location').lng

      Bronson.publish 'app:addmarker', coords

    render: ->
      $(@el).html(_.template(VenueItemTemplate, @model.toJSON()))
      @