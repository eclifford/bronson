define [
  'marionette'
  'text!modules/carousel/templates/carouselItemTemplate.html'
], (Marionette, CarouselItemTemplate) ->
  class CarouselItemView extends Marionette.ItemView
    className: 'item text-center'
    template: _.template(CarouselItemTemplate)




