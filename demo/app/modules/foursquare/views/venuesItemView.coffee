define [
  'marionette'
  'tpl!modules/foursquare/templates/venuesItemTemplate.tmpl'
], (Marionette, VenuesItemTemplate) ->
  class VenuesItemView extends Marionette.ItemView
    template: VenuesItemTemplate

    events:
      'click': 'selectVenue'

    selectVenue: ->
      coords =
        title: @model.get('name')
        lat: @model.get('location').lat
        lng: @model.get('location').lng

      Bronson.publish 'app:addmarker', coords