define [
  'jquery',
  'underscore',
  'backbone',
  'bronson',
  'apps/lib/foursquare/views/venueItemView',
  'text!apps/src/foursquare/templates/venuesTemplate.html'
], ($, _, Backbone, Bronson, VenueItemView, VenuesTemplate) ->
  class VenuesView extends Backbone.View
    tagName: 'li'
    className: 'module foursquare'

    events: ->
      'click .close': 'dispose'
      
    initialize: ->
      @id = Math.random().toString(36).substring(7)
      _.bindAll @, 'render'
      @collection.bind 'reset', @render

      Bronson.Core.subscribe 'FoursquareModule', 'message', (msg) =>
        $(@el).prepend("<div class='alert alert-success'>HEY FUCKER</div>")
        


    render: ->
      $(@el).html(_.template(VenuesTemplate, {id: @id}))

      _.each @collection.models, ((item) ->
        @renderItem item
      ), @
      @

    renderItem: (item) ->
      venueItemView = new VenueItemView
        model: item
      $(@el).append venueItemView.render().el

    dispose: ->
      #Bronson.Core.publish 'dispose'
      @collection.unbind 'change'
      @collection.dispose()
      $(@el).remove()



