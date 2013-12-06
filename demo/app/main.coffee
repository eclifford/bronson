#
# App Main - The entry point into the application
#
require ['common'], (common) ->
  require [
    'jquery'
    'bronson'
  ], ($, Bronson) ->
    Bronson.load [
      'modules/gmaps/main':
        data:
          el: '#main'
        autostart: true
    ,
      'modules/foursquare/main':
        data:
          el: '#main'
        autostart: true
    ,
      'modules/carousel/main':
        data:
          el: '#main'
        autostart: true
    ]

    $('#add-map').click ->
      Bronson.load [
        'modules/gmaps/main':
          data:
            el: '#main'
          autostart: true
      ]

    $('#add-instagram').click ->
      Bronson.load [
        'modules/carousel/main':
          data:
            el: '#main'
          autostart: true
      ]

    $('#add-foursquare').click ->
      Bronson.load [
        'modules/foursquare/main':
          data:
            el: '#main'
          autostart: true
      ]

