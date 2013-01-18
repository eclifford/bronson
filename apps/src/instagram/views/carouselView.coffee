define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/instagram/views/carouselItemView',
  'text!apps/src/instagram/templates/carouselTemplate.html'
], ($, _, Backbone, Bronson, CarouselItemView, CarouselTemplate) ->
  class CarouselView extends Backbone.View
    moduleId: null
    tagName: 'li'
    className: 'module instagram'
    started: true

    events: ->
      'click .close': 'dispose'
      'click .icon-stop': 'stop'
      'click .icon-play': 'start'

    initialize: ->
      _.bindAll @, 'render', 'dispose'
      @collection.bind 'reset', @render

    render: ->
      $(@el).html(_.template(CarouselTemplate, {id: @id}))

      _.each @collection.models, ((item) ->
        @renderItem item
      ), @
      $('div.carousel-inner div:first-child', @el).addClass('active')

      if @started
        $('.icon-play', @el).removeClass('inactive')
        $('.icon-stop', @el).addClass('inactive') 
      else
        $('.icon-stop', @el).removeClass('inactive')
        $('.icon-play', @el).addClass('inactive')        

      @

    stop: ->
      Bronson.stop @moduleId
      $('.icon-stop', @el).removeClass('inactive')
      $('.icon-play', @el).addClass('inactive')
      @started = false

    start: ->
      Bronson.start @moduleId
      $('.icon-play', @el).removeClass('inactive')
      $('.icon-stop', @el).addClass('inactive')
      @started = true


    renderItem: (item) ->
      carouselItemView = new CarouselItemView
        model: item
      $('div.carousel-inner', @el).append carouselItemView.render().el

    dispose: ->
      Bronson.unload @moduleId
      @collection.unbind 'change'
      @collection.dispose()
      $(@el).remove()



