define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/foursquare/templates/venueTemplate.html'
], ($, _, Backbone, Bronson, VenueItemTemplate) ->
  class VenueItemView extends Backbone.View
    initialize: ->

    render: ->
      $(@el).html(_.template(VenueItemTemplate, @model.toJSON()))
      @