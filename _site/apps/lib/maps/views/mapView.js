(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'text!apps/src/maps/templates/mapTemplate.html', 'async!http://maps.googleapis.com/maps/api/js?key=AIzaSyDTB9ap7VN6CRrMWaAS2cKwctgjn-_l_oA&sensor=false'], function($, _, Backbone, Bronson, MapTemplate) {
    var MapView;
    return MapView = (function(_super) {

      __extends(MapView, _super);

      function MapView() {
        return MapView.__super__.constructor.apply(this, arguments);
      }

      MapView.prototype.tagName = 'li';

      MapView.prototype.className = 'module maps';

      MapView.prototype.initialize = function() {
        var _this = this;
        this.id = Math.random().toString(36).substring(7);
        return Bronson.Core.subscribe('MapModule', 'geoUpdate', function(data) {
          var panLocation;
          panLocation = new google.maps.LatLng(data.latitude, data.longitude);
          return _this.map.panTo(panLocation);
        });
      };

      MapView.prototype.events = function() {
        return {
          'click .close': 'dispose'
        };
      };

      MapView.prototype.render = function() {
        var mapOptions,
          _this = this;
        mapOptions = {
          zoom: 14,
          center: new google.maps.LatLng(35.689488, 139.691706),
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        this.map = new google.maps.Map($(this.el).get(0), mapOptions);
        google.maps.event.addListener(this.map, 'click', function(event) {
          var coord;
          coord = {
            latitude: event.latLng.Xa,
            longitude: event.latLng.Ya
          };
          return Bronson.Core.publish('geoUpdate', coord);
        });
        Bronson.Api.subscribe('MapsModule', 'addMarker', function(data) {
          var latlng, marker;
          latlng = new google.maps.LatLng(data.latitude, data.longitude);
          marker = new google.maps.Marker({
            animation: google.maps.Animation.DROP,
            position: latlng,
            map: _this.map
          });
          return _this.map.panTo(latlng);
        });
        $(this.el).prepend(_.template(MapTemplate, {
          id: this.id
        }));
        return this;
      };

      MapView.prototype.dispose = function() {};

      return MapView;

    })(Backbone.View);
  });

}).call(this);
