define [
  'marionette'
  'modules/carousel/views/carouselItemView'
  'tpl!modules/carousel/templates/carouselTemplate.html'
  'bootstrap/carousel'
], (Marionette, CarouselItemView, CarouselTemplate) ->
  class CarouselView extends Marionette.CompositeView
    itemView: CarouselItemView
    className: 'module'
    itemViewContainer: '.carousel-inner'
    template: CarouselTemplate

    events: ->
      'click .glyphicon-remove': 'dispose'
      'click .glyphicon-stop': 'stop'
      'click .glyphicon-play': 'start'

    initialize: ->
      @templateHelpers =
        cid: @cid

    onRender: ->
      @$el.carousel().carousel('next')

    stop: ->
      Bronson.stop @moduleId
      $('.glyphicon-stop', @el).addClass('active')
      $('.glyphicon-play', @el).removeClass('active')
      @started = false

    start: ->
      Bronson.start @moduleId
      $('.glyphicon-stop', @el).removeClass('active')
      $('.glyphicon-play', @el).addClass('active')
      @started = true

    dispose: ->
      @close()
      
