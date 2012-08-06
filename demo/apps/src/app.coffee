require ['underscore', 'backbone', 'bronson'], (_, Backbone, Bronson) ->

  $('#btnAddInstagram').click ->
    Bronson.Api.createModule 'apps/lib/instagram/instagramModule',
      el: '#modules'
    , ->

  $('#btnAddTwitter').click ->
    Bronson.Api.createModule 'apps/lib/twitter/twitterModule',
      el: '#modules'
    , ->
  $('#btnAddWeather').click ->
    Bronson.Api.createModule 'apps/lib/weather/weatherModule',
      el: '#modules'
    , ->
  $('#btnAddMaps').click ->
    Bronson.Api.createModule 'apps/lib/maps/mapsModule',
      el: '#modules'
    , ->

  $('#btnAddFourSquare').click ->
    Bronson.Api.createModule 'apps/lib/foursquare/foursquareModule',
      el: '#modules'
    , ->

  $('#btnGetCurrentPosition').click ->
    if navigator && navigator.geolocation
      navigator.geolocation.getCurrentPosition (geo) ->
        Bronson.Api.publish 'geoUpdate', geo.coords 
      , (error) ->
        console.log 'failure'
    else
      console.log 'geolocation not supported'

  $('#btnSetPositionToTokyo').click ->
    coords =
      latitude: '35.689488'
      longitude: '139.691706'

    Bronson.Api.publish 'geoUpdate', coords 

  $('#btnSetPositionToLondon').click ->
    coords =
      latitude: '51.500152'
      longitude: '-0.126236'

    Bronson.Api.publish 'geoUpdate', coords 