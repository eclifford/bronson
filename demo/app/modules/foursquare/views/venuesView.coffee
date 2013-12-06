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