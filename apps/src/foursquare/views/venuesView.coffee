define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/foursquare/views/venueItemView',
  'text!apps/src/foursquare/templates/venuesTemplate.html'
], ($, _, Backbone, Bronson, VenueItemView, VenuesTemplate) ->
  class VenuesView extends Backbone.View
    moduleId: null
    tagName: 'li'
    className: 'module foursquare'
    started: true

    events: ->
      'click .close': 'dispose'
      'click .icon-stop': 'stop'
      'click .icon-play': 'start'
      
    initialize: ->
      _.bindAll @, 'render'
      @collection.bind 'reset', @render

    render: ->
      $(@el).html(_.template(VenuesTemplate, null))

      _.each @collection.models, ((item) ->
        @renderItem item
      ), @

      if @started
        $('.icon-play', @el).removeClass('inactive')
        $('.icon-stop', @el).addClass('inactive') 
      else
        $('.icon-stop', @el).removeClass('inactive')
        $('.icon-play', @el).addClass('inactive')        

      @

    renderItem: (item) ->
      venueItemView = new VenueItemView
        model: item
      $(@el).append venueItemView.render().el

    stop: ->
      Bronson.Api.stopModule @moduleId
      $('.icon-stop', @el).removeClass('inactive')
      $('.icon-play', @el).addClass('inactive')
      @started = false

    start: ->
      Bronson.Api.startModule @moduleId
      $('.icon-play', @el).removeClass('inactive')
      $('.icon-stop', @el).addClass('inactive')
      @started = true

    dispose: ->
      Bronson.Api.unloadModule @moduleId
      @collection.unbind 'change'
      @collection.dispose()
      $(@el).remove()



