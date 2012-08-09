(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'apps/lib/weather/model/weatherModel'], function(_, Backbone, WeatherModel) {
    var WeatherCollection;
    return WeatherCollection = (function(_super) {

      __extends(WeatherCollection, _super);

      function WeatherCollection() {
        return WeatherCollection.__super__.constructor.apply(this, arguments);
      }

      WeatherCollection.prototype.model = WeatherModel;

      WeatherCollection.prototype.url = "http://api.wunderground.com/api/2d04094a0883bebf/geolookup/forecast/q/";

      WeatherCollection.prototype.dispose = function() {
        this.reset([], {
          silent: true
        });
        this.off();
        return typeof Object.freeze === "function" ? Object.freeze(this) : void 0;
      };

      return WeatherCollection;

    })(Backbone.Collection);
  });

}).call(this);
