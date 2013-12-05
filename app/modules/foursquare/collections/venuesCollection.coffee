define [
  'backbone'
], (Backbone) ->
  class VenuesCollection extends Backbone.Collection
    url: "https://api.foursquare.com/v2/venues/search"

    parse: (response) ->
      return response.response.venues
