(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'bronson', 'apps/lib/maps/views/mapView'], function(_, Backbone, Bronson, MapView) {
    var MapModule;
    return MapModule = (function(_super) {

      __extends(MapModule, _super);

      function MapModule(config) {
        if (config == null) {
          config = {};
        }
        this.el = config.el;
      }

      MapModule.prototype.load = function() {
        var mapView;
        mapView = new MapView();
        mapView.moduleId = this.id;
        return $(this.el).append(mapView.render().el);
      };

      MapModule.prototype.start = function() {
        return MapModule.__super__.start.call(this);
      };

      MapModule.prototype.stop = function() {
        Bronson.Api.unsubscribeAll(this.id);
        return MapModule.__super__.stop.call(this);
      };

      MapModule.prototype.unload = function() {
        return MapModule.__super__.unload.call(this);
      };

      return MapModule;

    })(Bronson.Module);
  });

}).call(this);
