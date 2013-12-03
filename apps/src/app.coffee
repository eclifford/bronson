require ['underscore', 'backbone', 'bronson'], (_, Backbone, Bronson) ->

  # Bronson.load 'apps/lib/instagram/instagramModule'
  #   el: '#modules'
  # , (->)
  # , true

  # Bronson.load 'apps/lib/twitter/twitterModule'
  #   el: '#modules'
  # , (->)
  # , true

  # Bronson.load 'apps/lib/foursquare/foursquareModule'
  #   el: '#modules'
  # , (->)
  # , true

  Bronson.load [
    'apps/lib/instagram/instagramModule':
      autostart: true
      data: 
        el: '#modules'
  ,
    'apps/lib/maps/mapsModule':
      autostart: true
      data: 
        el: '#modules'
  ,
    'apps/lib/foursquare/foursquareModule':
      autostart: true
      data: 
        el: '#modules'
  ]



  $('#btnAddInstagram').click ->
    Bronson.load 'apps/lib/instagram/instagramModule'
      el: '#modules'
    , (->)
    , true

  # $('#btnAddTwitter').click ->
  #   Bronson.load 'apps/lib/twitter/twitterModule'
  #     el: '#modules'
  #   , (->)
  #   , true

  $('#btnAddFourSquare').click ->
    Bronson.load 'apps/lib/foursquare/foursquareModule'
      el: '#modules'
    , (->)
    , true

  $('#btnAddMaps').click ->
    Bronson.load [
      'apps/lib/maps/mapsModule': 
        autostart: true
        data:
          el: '#modules'
    ]


  $('#btnGetCurrentPosition').click ->
    if navigator && navigator.geolocation
      navigator.geolocation.getCurrentPosition (geo) ->
        Bronson.publish 'app:geoupdate', geo.coords 
      , (error) ->
        console.log 'failure'
    else
      console.log 'geolocation not supported'

  $('#btnSetPositionToSF').click ->
    coords =
      latitude: '37.788086'
      longitude: '-122.401111'
    Bronson.publish 'app:geoupdate', coords

  $('#btnSetPositionToTokyo').click ->
    coords =
      latitude: '35.689488'
      longitude: '139.691706'

    Bronson.publish 'app:geoupdate', coords 

  $('#btnSetPositionToLondon').click ->
    coords =
      latitude: '51.500152'
      longitude: '-0.126236'

    Bronson.publish 'app:geoupdate', coords 

  $('#btnSetPositionToParis').click ->
    coords =
      latitude: '48.858844300000001'
      longitude: ' 2.2943506'

    Bronson.publish 'app:geoupdate', coords 
