define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/instagram/views/carouselItemView',
  'text!apps/src/instagram/templates/carouselTemplate.html'
], ($, _, Backbone, Bronson, CarouselItemView, CarouselTemplate) ->
  class CarouselView extends Backbone.View
    tagName: 'li'
    className: 'module instagram'

    initialize: ->
      @id = Math.random().toString(36).substring(7)
      _.bindAll @, 'render', 'dispose'
      @collection.bind 'reset', @render

    events: ->
      'click .icon-remove-sign': 'dispose'

    render: ->
      $(@el).html(_.template(CarouselTemplate, {id: @id}))

      _.each @collection.models, ((item) ->
        @renderItem item
      ), @
      $('div.carousel-inner div:first-child', @el).addClass('active')
      @

    renderItem: (item) ->
      carouselItemView = new CarouselItemView
        model: item
      $('div.carousel-inner', @el).append carouselItemView.render().el

    dispose: ->
      Bronson.Core.publish 'dispose'
      @collection.unbind 'change'
      @collection.dispose()
      $(@el).remove()



