require ['underscore', 'backbone'], (_, Backbone) ->

  Bronson.Api.loadModule 'apps/lib/instagram/instagramModule', (->
  ),
    el: '#modules'
  , true

  Bronson.Api.loadModule 'apps/lib/twitter/twitterModule', (->
  ),
    el: '#modules'
  , true


  Bronson.Api.loadModule 'apps/lib/weather/weatherModule', (->
  ),
    el: '#modules'
  , true


  Bronson.Api.loadModule 'apps/lib/maps/mapsModule', (->
  ),
    el: '#modules'
  , true


  Bronson.Api.loadModule 'apps/lib/foursquare/foursquareModule', (->
  ),
    el: '#modules'
  , true



  $('#btnAddFourSquare').click ->
    Bronson.Api.loadModule 'apps/lib/foursquare/foursquareModule', (->
    ),
      el: '#modules'
    , true

  $('#btnAddInstagram').click ->
    Bronson.Api.loadModule 'apps/lib/instagram/instagramModule', (->
    ),
      el: '#modules'
    , true

  $('#btnAddTwitter').click ->
    Bronson.Api.loadModule 'apps/lib/twitter/twitterModule', (->
    ),
      el: '#modules'
    , true

  $('#btnAddWeather').click ->
    Bronson.Api.loadModule 'apps/lib/weather/weatherModule', (->
    ),
      el: '#modules'
    , true

  $('#btnAddMaps').click ->
    Bronson.Api.loadModule 'apps/lib/maps/mapsModule', (->
    ),
      el: '#modules'
    , true

  $('#btnAddFourSquare').click ->
    Bronson.Api.loadModule 'apps/lib/foursquare/foursquareModule',
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

  $('#btnRemoveModules').click ->
    Bronson.Api.stopAllModules()