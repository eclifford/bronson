(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'apps/lib/weather/models/weatherModel', 'apps/lib/weather/views/weatherView'], function($, _, Backbone, Bronson, WeatherModel, WeatherView) {
    var WeatherModule;
    return WeatherModule = (function(_super) {

      __extends(WeatherModule, _super);

      function WeatherModule(config) {
        if (config == null) {
          config = {};
        }
        this.el = config.el;
      }

      WeatherModule.prototype.load = function() {
        var _this = this;
        this.weatherModel = new WeatherModel();
        this.weatherView = new WeatherView({
          model: this.weatherModel
        });
        this.weatherView.moduleId = this.id;
        this.weatherModel.url = 'http://api.wunderground.com/api/2d04094a0883bebf/forecast/geolookup/conditions/q/Japan/Tokyo.json?callback=?';
        return this.weatherModel.fetch({
          silent: true,
          success: function() {
            return $(_this.el).append(_this.weatherView.render().el);
          }
        });
      };

      WeatherModule.prototype.start = function() {
        var _this = this;
        Bronson.Api.subscribe(this.id, 'geoUpdate', function(data) {
          _this.weatherModel.url = "http://api.wunderground.com/api/2d04094a0883bebf/forecast/geolookup/conditions/q/" + data.latitude + "," + data.longitude + ".json?callback=?";
          return _this.weatherModel.fetch();
        });
        return WeatherModule.__super__.start.call(this);
      };

      WeatherModule.prototype.stop = function() {
        Bronson.Api.unsubscribeAll(this.id);
        return WeatherModule.__super__.stop.call(this);
      };

      WeatherModule.prototype.unload = function() {
        return WeatherModule.__super__.unload.call(this);
      };

      return WeatherModule;

    })(Bronson.Module);
  });

}).call(this);
