define [
  'marionette'
  'modules/foursquare/views/venuesItemView'
  'tpl!modules/foursquare/templates/venuesTemplate.html'
], (Marionette, VenuesItemView, VenuesTemplate) ->
  class VenuesView extends Marionette.CompositeView
    template: VenuesTemplate
    itemView: VenuesItemView
    itemViewContainer: '.content'
    className: 'module'

    events: ->
      'click .close': 'dispose'
      'click .icon-stop': 'stop'
      'click .icon-play': 'start'

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

    dispose: ->
      Bronson.unload @moduleId
      @collection.unbind 'change'
      @collection.dispose()
      $(@el).remove()