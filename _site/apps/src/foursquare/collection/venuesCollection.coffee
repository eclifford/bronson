define [
  'underscore',
  'backbone',
  'apps/lib/foursquare/model/venueModel'
], (_, Backbone, VenueModel) ->

  class VenuesCollection extends Backbone.Collection
    model: VenueModel
    url: "https://api.foursquare.com/v2/venues/search",
    
    parse: (response) ->
      return response.response.venues
    
    dispose: ->
      @reset [], silent: true
      @off()

      Object.freeze? @