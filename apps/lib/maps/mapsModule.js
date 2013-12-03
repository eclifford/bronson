(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'bronson', 'apps/lib/maps/views/mapView', 'javascripts/vendor/gmaps'], function(_, Backbone, Bronson, MapView) {
    var MapModule;
    return MapModule = (function(_super) {

      __extends(MapModule, _super);

      function MapModule(config) {
        if (config == null) {
          config = {};
        }
        this.el = config.el;
      }

      MapModule.prototype.onLoad = function() {
        var mapView;
        console.log(this.el);
        mapView = new MapView();
        mapView.moduleId = this.id;
        console.log(this.id);
        $(this.el).append(mapView.render().el);
        return this.map = new GMaps({
          el: $('.map', mapView.el).get(0),
          lat: 37,
          lng: -122,
          zoom: 13,
          scrollwheel: false
        });
      };

      MapModule.prototype.onStart = function() {
        var _this = this;
        return Bronson.subscribe('maps:app:geoupdate', function(data) {
          return _this.map.setCenter(data.latitude, data.longitude);
        });
      };

      MapModule.prototype.onStop = function() {
        alert('stopped!');
        return Bronson.unsubscribe('maps');
      };

      MapModule.prototype.onUnload = function() {};

      return MapModule;

    })(Bronson.Module);
  });

}).call(this);
