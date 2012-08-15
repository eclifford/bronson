(function() {

  require(['underscore', 'backbone', 'bronson'], function(_, Backbone, Bronson) {
    Bronson.Api.loadModule('apps/lib/instagram/instagramModule', (function() {}), {
      el: '#modules'
    }, true);
    Bronson.Api.loadModule('apps/lib/twitter/twitterModule', (function() {}), {
      el: '#modules'
    }, true);
    Bronson.Api.loadModule('apps/lib/maps/mapsModule', (function() {}), {
      el: '#modules'
    }, true);
    Bronson.Api.loadModule('apps/lib/foursquare/foursquareModule', (function() {}), {
      el: '#modules'
    }, true);
    $('#btnAddFourSquare').click(function() {
      return Bronson.Api.loadModule('apps/lib/foursquare/foursquareModule', (function() {}), {
        el: '#modules'
      }, true);
    });
    $('#btnAddInstagram').click(function() {
      return Bronson.Api.loadModule('apps/lib/instagram/instagramModule', (function() {}), {
        el: '#modules'
      }, true);
    });
    $('#btnAddTwitter').click(function() {
      return Bronson.Api.loadModule('apps/lib/twitter/twitterModule', (function() {}), {
        el: '#modules'
      }, true);
    });
    $('#btnAddWeather').click(function() {
      return Bronson.Api.loadModule('apps/lib/weather/weatherModule', (function() {}), {
        el: '#modules'
      }, true);
    });
    $('#btnAddMaps').click(function() {
      return Bronson.Api.loadModule('apps/lib/maps/mapsModule', (function() {}), {
        el: '#modules'
      }, true);
    });
    $('#btnGetCurrentPosition').click(function() {
      if (navigator && navigator.geolocation) {
        return navigator.geolocation.getCurrentPosition(function(geo) {
          return Bronson.Api.publish('geoUpdate', geo.coords);
        }, function(error) {
          return console.log('failure');
        });
      } else {
        return console.log('geolocation not supported');
      }
    });
    $('#btnSetPositionToTokyo').click(function() {
      var coords;
      coords = {
        latitude: '35.689488',
        longitude: '139.691706'
      };
      return Bronson.Api.publish('geoUpdate', coords);
    });
    $('#btnSetPositionToLondon').click(function() {
      var coords;
      coords = {
        latitude: '51.500152',
        longitude: '-0.126236'
      };
      return Bronson.Api.publish('geoUpdate', coords);
    });
    return $('#btnSetPositionToParis').click(function() {
      var coords;
      coords = {
        latitude: '48.858844300000001',
        longitude: ' 2.2943506'
      };
      return Bronson.Api.publish('geoUpdate', coords);
    });
  });

}).call(this);
