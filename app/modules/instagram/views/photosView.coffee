#
# Instagram photos presented in a bootstrap grid
#
define [
  'underscore'
  'backbone'
  'marionette'
  'modules/instagram/views/photoView'
  'tpl!modules/instagram/templates/photosTemplate.html'
], (_, Backbone, Marionette, PhotoView, PhotosTemplate) ->
  class PhotosGridView extends Marionette.CompositeView
    itemView: PhotoView
    template: PhotosTemplate
    itemViewContainer: '.module-content'

    events:
      'click .glyphicon-stop': 'stop'
      'click .glyphicon-play': 'start'

    stop: (e) ->
      Bronson.publish 'instagram:stop'
      $(e.currentTarget).addClass('active')
      $('.glyphicon-play').removeClass('active')

    start: (e) ->
      Bronson.publish 'instagram:start'
      $(e.currentTarget).addClass('active')
      $('.glyphicon-stop').removeClass('active')

    onRender: ->
      Bronson.publish 'instagram:update',
        markers: @collection

      Bronson.subscribe 'instagram:map:markerselected', (data) =>
        $('.photo-item', @$el).removeClass('active')
        $("##{data.id}").addClass('active')

      $children = @$el.find('.photo-item')
      i = 0
      l = $children.length

      while i < l
        $children.slice(i, i + 4).wrapAll "<div class='row'></div>"
        i += 4


