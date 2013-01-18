define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/instagram/templates/carouselItemTemplate.html'
], ($, _, Backbone, Bronson, CarouselItemTemplate) ->
  class CarouselItemView extends Backbone.View
    className: 'item'

    events: 
      "click": 'notify'

    initialize: ->

    notify: ->

      coords = 
        latitude: @model.get('location').latitude
        longitude: @model.get('location').longitude

      Bronson.publish 'app:addmarker', coords

    render: ->
      $(@el).html(_.template(CarouselItemTemplate, @model.toJSON()))
      @