define [
  'marionette'
  'tpl!modules/gmaps/templates/mapTemplate.tmpl'
], (Marionette, MapTemplate) ->
  class MapView extends Marionette.CompositeView
    template: MapTemplate
    className: 'module'

    events: ->
      'click .glyphicon-remove': 'dispose'
      'click .glyphicon-stop': 'stop'
      'click .glyphicon-play': 'start'

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
