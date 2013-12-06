define [
  'marionette'
  'text!modules/carousel/templates/carouselItemTemplate.html'
], (Marionette, CarouselItemTemplate) ->
  class CarouselItemView extends Marionette.ItemView
    className: 'item text-center'
    template: _.template(CarouselItemTemplate)

    events:
      'click': 'selectImage'

    selectImage: ->
      coords =
        lat: @model.get('location').latitude
        lng: @model.get('location').longitude

      Bronson.publish 'app:addmarker', coords
