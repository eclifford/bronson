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

      Bronson.Api.publish 'addMarker', @model.toJSON() 

    render: ->
      $(@el).html(_.template(CarouselItemTemplate, @model.toJSON()))
      @