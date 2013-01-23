(function() {

  require(['underscore', 'backbone', 'bronson'], function(_, Backbone, Bronson) {
    Bronson.load('apps/lib/twitter/twitterModule', {
      el: '#modules'
    }, (function() {}), true);
    Bronson.load('apps/lib/foursquare/foursquareModule', {
      el: '#modules'
    }, (function() {}), true);
    Bronson.load('apps/lib/maps/mapsModule', {
      el: '#modules'
    }, (function() {}), true);
    $('#btnAddInstagram').click(function() {
      return Bronson.load('apps/lib/instagram/instagramModule', {
        el: '#modules'
      }, (function() {}), true);
    });
    $('#btnAddTwitter').click(function() {
      return Bronson.load('apps/lib/twitter/twitterModule', {
        el: '#modules'
      }, (function() {}), true);
    });
    $('#btnAddFourSquare').click(function() {
      return Bronson.load('apps/lib/foursquare/foursquareModule', {
        el: '#modules'
      }, (function() {}), true);
    });
    $('#btnAddMaps').click(function() {
      return Bronson.load('apps/lib/maps/mapsModule', {
        el: '#modules'
      }, (function() {}), true);
    });
    $('#btnGetCurrentPosition').click(function() {
      if (navigator && navigator.geolocation) {
        return navigator.geolocation.getCurrentPosition(function(geo) {
          return Bronson.publish('app:geoupdate', geo.coords);
        }, function(error) {
          return console.log('failure');
        });
      } else {
        return console.log('geolocation not supported');
      }
    });
    $('#btnSetPositionToSF').click(function() {
      var coords;
      coords = {
        latitude: '37.788086',
        longitude: '-122.401111'
      };
      return Bronson.publish('app:geoupdate', coords);
    });
    $('#btnSetPositionToTokyo').click(function() {
      var coords;
      coords = {
        latitude: '35.689488',
        longitude: '139.691706'
      };
      return Bronson.publish('app:geoupdate', coords);
    });
    $('#btnSetPositionToLondon').click(function() {
      var coords;
      coords = {
        latitude: '51.500152',
        longitude: '-0.126236'
      };
      return Bronson.publish('app:geoupdate', coords);
    });
    return $('#btnSetPositionToParis').click(function() {
      var coords;
      coords = {
        latitude: '48.858844300000001',
        longitude: ' 2.2943506'
      };
      return Bronson.publish('app:geoupdate', coords);
    });
  });

}).call(this);
