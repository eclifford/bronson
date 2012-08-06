define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'text!apps/src/instagram/templates/carouselItemTemplate.html'
], ($, _, Backbone, Bronson, CarouselItemTemplate) ->
  class CarouselItemView extends Backbone.View
    className: 'item'

    initialize: ->

    render: ->
      $(@el).html(_.template(CarouselItemTemplate, @model.toJSON()))
      @