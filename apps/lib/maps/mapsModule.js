(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'bronson', 'apps/lib/maps/views/mapView'], function(_, Backbone, Bronson, MapView) {
    var MapModule;
    return MapModule = (function(_super) {

      __extends(MapModule, _super);

      function MapModule(parameters) {
        if (parameters == null) {
          parameters = {};
        }
        this.id = Math.random().toString(36).substring(7);
        this.el = parameters.el;
      }

      MapModule.prototype.load = function() {
        var mapView;
        mapView = new MapView();
        return $(this.el).append(mapView.render().el);
      };

      MapModule.prototype.start = function() {};

      MapModule.prototype.stop = function() {};

      MapModule.prototype.unload = function() {};

      return MapModule;

    })(Bronson.Module);
  });

}).call(this);
