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

    events: ->
      # 'click': 'dispose'
      'click .icon-stop': 'stop'
      
    initialize: ->
      _.bindAll @, 'render'
      @collection.bind 'reset', @render

    render: ->
      $(@el).html(_.template(VenuesTemplate, null))

      _.each @collection.models, ((item) ->
        @renderItem item
      ), @
      @

    renderItem: (item) ->
      venueItemView = new VenueItemView
        model: item
      $(@el).append venueItemView.render().el

    stop: ->
      console.log 'stop clicked'
      Bronson.Core.stopAllModules()

    dispose: ->
      Bronson.Api.unloadModule @moduleId
      @collection.unbind 'change'
      @collection.dispose()
      $(@el).remove()



