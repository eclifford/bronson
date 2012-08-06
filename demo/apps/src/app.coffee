require ['underscore', 'backbone', 'bronson'], (_, Backbone, Bronson) ->
  instagram = false





  # Bronson.Core.createModule 'apps/lib/foursquare/foursquareModule'
  #   el: '#logger'
  # , ->
  #   console.load 'loaded'
  $('#btnAddInstagram').click ->
    # if !instagram 
    Bronson.Core.createModule 'apps/lib/instagram/instagramModule',
      el: '#modules'
    , ->
      instagram = true
    # else 
    #   Bronson.Core.stopModule 'apps/lib/instagram/instagramModule', ->
    #     instagram = false

  $('#btnAddTwitter').click ->
    Bronson.Core.createModule 'apps/lib/twitter/twitterModule',
      el: '#modules'
    , ->
  $('#btnAddWeather').click ->
    Bronson.Core.createModule 'apps/lib/weather/weatherModule',
      el: '#modules'
    , ->
  $('#btnAddMaps').click ->
    Bronson.Core.createModule 'apps/lib/maps/mapsModule',
      el: '#modules'
    , ->

  $('#btnAddFourSquare').click ->
    Bronson.Core.createModule 'apps/lib/foursquare/foursquareModule',
      el: '#modules'
    , ->

  $('#btnGetCurrentPosition').click ->
    if navigator && navigator.geolocation
      navigator.geolocation.getCurrentPosition (geo) ->
        Bronson.Core.publish 'geoUpdate', geo.coords 
      , (error) ->
        console.log 'failure'
    else
      console.log 'geolocation not supported'