define [
  'marionette'
  'tpl!modules/gmaps/templates/mapTemplate.html'
], (Marionette, MapTemplate) ->
  class MapView extends Marionette.CompositeView
    template: MapTemplate
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
      $(@el).remove()
