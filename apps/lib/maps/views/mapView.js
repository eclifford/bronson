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

      MapView.prototype.moduleId = null;

      MapView.prototype.tagName = 'li';

      MapView.prototype.className = 'module maps';

      MapView.prototype.started = true;

      MapView.prototype.initialize = function() {};

      MapView.prototype.events = function() {
        return {
          'click .close': 'dispose',
          'click .icon-stop': 'stop',
          'click .icon-play': 'start'
        };
      };

      MapView.prototype.render = function() {
        var mapOptions,
          _this = this;
        Bronson.Api.subscribe(this.moduleId, 'geoUpdate', function(data) {
          var panLocation;
          panLocation = new google.maps.LatLng(data.latitude, data.longitude);
          return _this.map.panTo(panLocation);
        });
        Bronson.Api.subscribe(this.moduleId, 'addMarker', function(data) {
          var latlng, marker;
          latlng = new google.maps.LatLng(data.latitude, data.longitude);
          marker = new google.maps.Marker({
            animation: google.maps.Animation.DROP,
            position: latlng,
            map: _this.map
          });
          return _this.map.panTo(latlng);
        });
        mapOptions = {
          zoom: 14,
          center: new google.maps.LatLng(35.689488, 139.691706),
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          mapTypeControl: false
        };
        $(this.el).prepend(_.template(MapTemplate, null));
        this.map = new google.maps.Map($('.map', this.el).get(0), mapOptions);
        google.maps.event.addListener(this.map, 'click', function(event) {
          var coord;
          coord = {
            latitude: event.latLng.Xa,
            longitude: event.latLng.Ya
          };
          return Bronson.Core.publish('geoUpdate', coord);
        });
        if (this.started) {
          $('.icon-play', this.el).removeClass('inactive');
          $('.icon-stop', this.el).addClass('inactive');
        } else {
          $('.icon-stop', this.el).removeClass('inactive');
          $('.icon-play', this.el).addClass('inactive');
        }
        return this;
      };

      MapView.prototype.stop = function() {
        Bronson.Api.stopModule(this.moduleId);
        $('.icon-stop', this.el).removeClass('inactive');
        $('.icon-play', this.el).addClass('inactive');
        return this.started = false;
      };

      MapView.prototype.start = function() {
        Bronson.Api.startModule(this.moduleId);
        $('.icon-play', this.el).removeClass('inactive');
        $('.icon-stop', this.el).addClass('inactive');
        return this.started = true;
      };

      MapView.prototype.dispose = function() {
        Bronson.Api.unloadModule(this.moduleId);
        this.collection.unbind('change');
        this.collection.dispose();
        return $(this.el).remove();
      };

      return MapView;

    })(Backbone.View);
  });

}).call(this);
