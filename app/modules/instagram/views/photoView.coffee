#
# Instagram photo
#
define [
  'marionette'
  'tpl!modules/instagram/templates/photoTemplate.html'
], (Marionette, PhotoTemplate) ->
  class PhotoView extends Marionette.ItemView
    template: PhotoTemplate
    className: 'col-sm-3 col-xs-3 photo-item'

    events:
      "click": "photoSelected"

    onRender: ->
      @$el.attr 'id', @model.get('id')

    photoSelected: (e) ->
      $('.photo-item').removeClass 'active'
      @$el.addClass 'active'
      Bronson.publish 'instagram:imageselected',
        photo: @model
