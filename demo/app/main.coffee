#
# App Main - The entry point into the application
#
require ['common'], (common) ->
  require [
    'jquery'
    'bronson'
  ], ($, Bronson) ->

    Bronson.load [
      id: Math.random().toString(36).substring(7)
      path: 'modules/gmaps/main'
      data:
        el: '#main'
      options:
        autostart: true
    ,
      id: Math.random().toString(36).substring(7)
      path: 'modules/foursquare/main'
      data:
        el: '#main'
      options:
        autostart: true
    ,
      id: Math.random().toString(36).substring(7)
      path: 'modules/carousel/main'
      data:
        el: '#main'
      options:
        autostart: true
    ]

    $('#add-map').click ->
      Bronson.load
        id: Math.random().toString(36).substring(7)
        path: 'modules/gmaps/main'
        data:
          el: '#main'
        options:
          autostart: true

    $('#add-instagram').click ->
      Bronson.load
        id: Math.random().toString(36).substring(7)
        path: 'modules/carousel/main'
        data:
          el: '#main'
        options:
          autostart: true

    $('#add-foursquare').click ->
      Bronson.load
        id: Math.random().toString(36).substring(7)
        path: 'modules/foursquare/main'
        data:
          el: '#main'
        options:
          autostart: true
